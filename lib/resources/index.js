const functions = require('firebase-functions');
const admin = require('firebase-admin');
const algoliasearch = require('algoliasearch');

const ALGOLIA_APP_ID = "7ID12WNW47";
const ALGOLIA_ADMIN_KEY = "ca453a0a6774d8ff442461a19255a533";
const ALGOLIA_INDEX_NAME = "b2b_businesses";

admin.initializeApp(functions.config().firebase);
//const firestore = admin.firestore;

exports.createPost = functions.firestore
    .document('User/{UserId}/Posts/{PostsID}')
    .onCreate( async (snap, context) => {
        const newValue = snap.data();
        newValue.objectID = snap.id;
       
        var client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);

        var index = client.initIndex(ALGOLIA_INDEX_NAME);
        index.saveObject(newValue);
        console.log("Finished");
    });

exports.updatePost = functions.firestore
    .document('User/{UserId}/Posts/{PostsID}')
    .onUpdate( async (snap, context) => {
        const afterUpdate = snap.after.data();
        afterUpdate.objectID =  snap.after.id;

        var client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);
        
        var index = client.initIndex(ALGOLIA_INDEX_NAME);
        index.saveObject(afterUpdate);
    });

exports.deletePost = functions.firestore
    .document('User/{UserId}/Posts/{PostsID}')
    .onDelete( async (snap, context) => {
        const oldID = snap.id;
        var client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);

        var index = client.initIndex(ALGOLIA_INDEX_NAME);
        index.deleteObject(oldID);
    });