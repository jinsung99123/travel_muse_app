const functions = require('firebase-functions');
const admin = require('firebase-admin');
const sharp = require('sharp');
const { Storage } = require('@google-cloud/storage');
const path = require('path');
const os = require('os');
const fs = require('fs');

admin.initializeApp();
const db = admin.firestore();
const storage = new Storage();


exports.deleteOrphanedAuthUsers = functions.pubsub
    .schedule('every day 00:00')
    .timeZone('Asia/Seoul')
    .onRun(async (context) => {
        const authUsers = await admin.auth().listUsers();
        const appUserDocs = await db.collection('appUser').get();

        const existingUids = new Set(appUserDocs.docs.map(doc => doc.id));

        for (const user of authUsers.users) {
            if (!existingUids.has(user.uid)) {
                try {
                    await admin.auth().deleteUser(user.uid);
                    console.log(`✅ Deleted Auth user: ${user.uid}`);
                } catch (error) {
                    console.error(`❌ Failed to delete Auth user: ${user.uid}`, error);
                }
            }
        }
    });

exports.generateThumbnailOnPostCreate = functions.firestore
    .document('posts/{postId}')
    .onCreate(async (snap, context) => {
        const postData = snap.data();
        const postId = context.params.postId;

        const images = postData.images;
        if (!images || !Array.isArray(images) || images.length === 0) {
            console.log(`🚫 No image found for post ${postId}`);
            return null;
        }

        const imageUrl = images[0];

        const matches = decodeURIComponent(imageUrl).match(/\/o\/(.+)\?alt=media/);
        if (!matches || matches.length < 2) {
            console.error(`❌ Invalid image URL format: ${imageUrl}`);
            return null;
        }

        const filePath = matches[1];
        const bucket = admin.storage().bucket();


        const tempOriginalPath = path.join(os.tmpdir(), `original_${Date.now()}`);
        const tempThumbPath = path.join(os.tmpdir(), `thumb_${Date.now()}.jpg`);

        try {
            // 원본 이미지 다운로드
            await bucket.file(filePath).download({ destination: tempOriginalPath });

            const image = sharp(tempOriginalPath);
            const metadata = await image.metadata();
            const width = metadata.width;
            const height = metadata.height;

            if (!width || !height) {
                console.error(`❌ Cannot determine image dimensions for: ${filePath}`);
                return null;
            }

            const resizeOptions = width < height ? { width: 72 } : { height: 72 };

            await image
                .resize(resizeOptions)
                .jpeg({ quality: 80 })
                .toFile(tempThumbPath);

            const thumbPath = `thumbnails/${postId}_thumbnail.jpg`;

            await bucket.upload(tempThumbPath, {
                destination: thumbPath,
                metadata: {
                    contentType: 'image/jpeg',
                    cacheControl: 'public, max-age=31536000',
                },
                predefinedAcl: 'publicRead',
            });

            const thumbUrl = `https://storage.googleapis.com/${bucket.name}/${thumbPath}`;

            await db.collection('posts').doc(postId).update({
                thumbnail: thumbUrl,
            });

            console.log(`✅ Thumbnail uploaded and URL saved for post ${postId}`);
        } catch (error) {
            console.error(`❌ Error processing thumbnail for post ${postId}:`, error);
        } finally {
            // 임시 파일 삭제
            if (fs.existsSync(tempOriginalPath)) fs.unlinkSync(tempOriginalPath);
            if (fs.existsSync(tempThumbPath)) fs.unlinkSync(tempThumbPath);
        }

        return null;
    });


exports.setAdminByEmail = functions.https.onCall(async (data, context) => {
    const requester = await admin.auth().getUser(context.auth.uid);
    if (!requester.customClaims?.admin) {
        throw new functions.https.HttpsError('permission-denied', '관리자만 실행할 수 있습니다.');
    }

    const email = data.email;

    try {
        const user = await admin.auth().getUserByEmail(email);
        await admin.auth().setCustomUserClaims(user.uid, { admin: true });
        return { message: `${email}에게 관리자 권한이 부여되었습니다.` };
    } catch (error) {
        throw new functions.https.HttpsError('not-found', '해당 이메일을 가진 사용자를 찾을 수 없습니다.');
    }
    });

exports.revokeAdminByEmail = functions.https.onCall(async (data, context) => {
  const requester = await admin.auth().getUser(context.auth.uid);
  if (!requester.customClaims?.admin) {
    throw new functions.https.HttpsError('permission-denied', '관리자만 실행할 수 있습니다.');
  }

  const email = data.email;

  try {
    const user = await admin.auth().getUserByEmail(email);
    await admin.auth().setCustomUserClaims(user.uid, {}); 
    return { message: `${email} 의 관리자 권한이 박탈되었습니다.` };
  } catch (error) {
    throw new functions.https.HttpsError('not-found', '해당 이메일의 사용자를 찾을 수 없습니다.');
  }
});

///게시글 30일 뒤에 자동 삭제
exports.deleteOldDeletedPosts = functions.pubsub.schedule("every 24 hours").onRun(async (context) => {
    const firestore = admin.firestore();
    const now = admin.firestore.Timestamp.now();
    const cutoff = new Date(now.toDate().getTime() - 30 * 24 * 60 * 60 * 1000);
  
    const snapshot = await firestore.collection("posts")
      .where("isDeleted", "==", true)
      .where("createdAt", "<", cutoff)
      .get();
  
    const deletePromises = snapshot.docs.map(doc => doc.ref.delete());
    await Promise.all(deletePromises);
  
    console.log(`Deleted ${deletePromises.length} posts`);
    return null;
  });

