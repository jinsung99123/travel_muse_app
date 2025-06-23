const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();
const db = admin.firestore();

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
