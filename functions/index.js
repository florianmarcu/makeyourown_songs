const functions = require("firebase-functions");
const admin = require('firebase-admin');

const { onSchedule } = require("firebase-functions/v2/scheduler");
admin.initializeApp();

const firestore = admin.firestore();

/// Get max number index from 3 numbers
function max(a, b, c){
  if(a > b){
    if(b > c){
      /// a > b > c
      return 0;
    }
    else{
      if(a > c){
        /// a > c > b
        return 0;
      }
      /// c > a > b
      else return 2;
    }
  }
  else{
    if(a > c){
      /// b > a > c
      return 1;
    }
    /// b > c > a
    else if(b > c)
      return 1;
    /// c > b > a
    else return 2;
  }
}

function getRandomInt(max) {
  return Math.floor(Math.random() * max);
}

// exports.startRoom = functions.https.onRequest(async (req, res) => {
//   // Trigger the scheduled function by publishing a message to the Pub/Sub topic
//   // const pubSub = new admin.pubsub.v1.PublisherClient();
//   // const topicName = 'start-scheduled-function-topic';
//   const {roomId} =  req.body;

//   // Schedule the function to run every 5 minutes
//   const runtimeOptions = {
//     timeoutSeconds: 300,
//   };
//   const intervalInMinutes = 5;

//   const message = {
//     text: "aaaa"
//   };
  
//   /// Start room
//   const db = admin.firestore();
//   const doc = await db.collection('rooms').doc(`${roomId}`);
//   doc.update(
//     {
//       "active": true
//     }
//   );
  

//   /// Define job
//   const job = functions.pubsub.schedule(`every ${intervalInMinutes} minutes`)
//     .onRun(async (context) => {
//       /// Get room from db
//       const db = admin.firestore();
//       const doc = await db.collection('rooms').doc(`${roomId}`).get();
//       const data = doc.data();
//       /// Find index of max
//       const indexOfMax = max(data['vote_count_0'], data['vote_count_1'], data['vote_count_2'])

//       const songs = data['current_songs'];
//       var currentDate = new Date();
//       /// Update elected song and next date
//       await doc.ref.update(
//         {
//           last_elected_song: {
//             song: songs[indexOfMax].song,
//             artist: songs[indexOfMax].artist
//           },
//           last_elected_date: admin.firestore.FieldValue.serverTimestamp(),
//           next_date: currentDate.setMinutes(currentDate.getMinutes() + 1)
//         },
//       )
//     });

//   /// Start job
//   return job.call();
//   // return job
//   //   .then((jobResponse) => {
//   //     console.log(`Scheduled function ${functionName} started successfully.`);
//   //     return res.send({ message: `Scheduled function ${functionName} started successfully.` });
//   //   })
//   //   .catch((error) => {
//   //     console.error('Error starting scheduled function:', error);
//   //     throw new functions.https.HttpsError('internal', 'Error starting scheduled function');
//   //   });


//   // // Publish a message to the topic
//   // pubSub.publish({
//   //   topic: topicName,
//   //   json: message,
//   // }, (error, messageId) => {
//   //   if (error) {
//   //     console.error('Error publishing message:', error);
//   //     response.status(500).send('Error publishing message');
//   //     return;
//   //   }

//   //   console.log('Message published:', messageId);
//   //   response.json({ message: 'Scheduled function will start shortly.' });
//   // });
// });


exports.scheduledFunction = functions.pubsub
  .schedule("every 1 minutes")
  .onRun(async (context) => {

  /// Get active room
  const db = admin.firestore();
  const query = await db.collection('rooms').where("active", "==", true).get();
  if(query.docs.length == 0)
    return;
  
  const doc = query.docs[0];
  const data = doc.data();

  /// Find index of max
  const indexOfMax = max(data['vote_count_0'], data['vote_count_1'], data['vote_count_2'])

  const songs = data['current_songs'];
  var currentDate = new Date();
  var nextDate = new Date(currentDate.getFullYear(), currentDate.getMonth(), currentDate.getDate(), currentDate.getHours(), currentDate.getMinutes() + 1, currentDate.getSeconds())
  console.log(nextDate)
  /// Next queued songs

  const allSongs = await db.collection('songs').get();
  var seed1 = getRandomInt(allSongs.docs.length);
  var seed2 = getRandomInt(allSongs.docs.length);
  var seed3 = getRandomInt(allSongs.docs.length);
  while(seed2 == seed1 || seed2 == seed3 || seed1 == seed3){
    seed1 = getRandomInt(allSongs.docs.length);
    seed2 = getRandomInt(allSongs.docs.length);
    seed3 = getRandomInt(allSongs.docs.length);
  }
  const queuedSong1 = allSongs.docs[seed1]
  const queuedSong2 = allSongs.docs[seed2]
  const queuedSong3 = allSongs.docs[seed3]

  var queuedSongs = [
    {
      song: queuedSong1.data()['song'],
      artist: queuedSong1.data()['artist'],
    },
    {
      song: queuedSong2.data()['song'],
      artist: queuedSong2.data()['artist'],
    },
    {
      song: queuedSong3.data()['song'],
      artist: queuedSong3.data()['artist'],
    }
  ];

  try{

    /// Update elected song and next date
    await doc.ref.update(
      {
        last_elected_song: {
          song: songs[indexOfMax].song,
          artist: songs[indexOfMax].artist,
        },
        last_elected_date: currentDate,
        vote_count_0: 0,
        vote_count_1: 0,
        vote_count_2: 0,
        current_songs: data['queued_songs'], 
        queued_songs: queuedSongs,
        next_date: nextDate
      },
    )
  }
  catch(e){
    console.log(e)
  }
  

  const voteCountOfMax = data[`vote_count_${indexOfMax}`]

  /// Add new elected song
  await doc.ref.collection("song_history").doc().set(
    {
      song: songs[indexOfMax].song,
      artist: songs[indexOfMax].artist,
      vote_count: voteCountOfMax,
      date_added: currentDate
    }
  );

  return;
});

// exports.StartRoom = functions.pubsub.schedule('every 5 minutes').forHours(6).onRun((context) => {

// });
// exports.EndRoom = functions.https.onRequest(async (req, res) => {

// });