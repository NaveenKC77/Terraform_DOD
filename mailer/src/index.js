import AWS from 'aws-sdk';
import nodemailer from 'nodemailer';

const sqs = new AWS.SQS({ apiVersion: '2012-11-05' });

// Initialize Mailtrap transporter
var transporter = nodemailer.createTransport({
    host: "sandbox.smtp.mailtrap.io",
    port: 2525,
    auth: {
        user: process.env.MAILJET_USER,
        pass: process.env.MAILJET_PASS,
    }
});

export const handler = async (event) => {
    for (const record of event.Records) {
        try {
            // Parse the message body
            const messageBody = JSON.parse(record.body);
            const { email, mailBody } = messageBody.message;

            // Send email using Mailtrap
            const mailOptions = {
                from: 'admin@dod.com', // Sender email
                to: email, // Recipient email
                subject: 'Verification Link',
                text: `Click the link to verify your account: ${mailBody}`,
            };

            await transporter.sendMail(mailOptions);
            console.log(`Email sent to ${email}`);

            // Delete the processed message from the SQS queue
            const deleteParams = {
                QueueUrl: getQueueUrlFromEvent(record.eventSourceARN),
                ReceiptHandle: record.receiptHandle,
            };

            await sqs.deleteMessage(deleteParams).promise();
            console.log(`Message deleted from queue: ${record.messageId}`);
        } catch (error) {
            console.error(`Error processing message: ${record.messageId}`, error);

        }
    }
};

// use queue url to process the message
const getQueueUrlFromEvent = (eventSourceARN) => {
    const [region, accountId, queueName] = eventSourceARN.split(':').slice(-3);
    return `https://sqs.${region}.amazonaws.com/${accountId}/${queueName}`;
};