const AWS = require('aws-sdk');
const SNS = new AWS.SNS();

const callback_id = process.env.CALLBACK_ID;
const topic_arn = process.env.TOPIC_ARN;

/**
 * Process SNS message.
 *
 * @param {object} event SNS event object.
 * @param {object} context SNS context object.
 * @param {function} callback Lambda callback function.
 */
exports.handler = (event, context, callback) => {
  // Log it
  console.log(`EVENT ${JSON.stringify(event)}`);

  // Map it
  event.Records.map((record) => {

    // Parse it
    const msg = JSON.parse(Buffer.from(record.Sns.Message, 'base64').toString());

    // Post it
    console.log(`MESSAGE ${JSON.stringify(msg)}`);
    return SNS.publish({
        Message: msg.submission[callback_id],
        TopicArn: topic_arn
      }, (err, data) => {
        if (err) {
          console.error(err);
          return callback(err);
        }
        console.log(`SNS ${JSON.stringify(data)}`);
        callback();
      });
  });
}
