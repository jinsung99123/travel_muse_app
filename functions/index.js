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