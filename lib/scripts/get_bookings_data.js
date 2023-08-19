// npm install crypto-js

const https = require('https');
var CryptoJS = require("crypto-js");
const util = require('util')
const fs = require('fs');

async function getPostResponse(requestMethod, accessSecret, data)
{

    var signature = CryptoJS.HmacSHA1(data, accessSecret).toString()

    const headers = {
        'Content-Type': 'application/json',
        'X-HAPI-Signature': signature,
        'Cookie': 'PHPSESSID=6bpfitbg63fbj60erg79atvhl3'
    };

    const actionUrl = `https://crs.staygrid.com/ws/web/${requestMethod}`;

    const requestOptions = {
        method: 'POST',
        headers: headers
    };

    const response = await new Promise((resolve, reject) => {
        req = https.request(actionUrl, requestOptions, (response) => {
            let responseData = '';

            response.on('data', (chunk) => {
                responseData += chunk;
            });

            response.on('end', () => {
                // console.log(JSON.parse(responseData)['hotelogix']['response']['days']);
                // console.log(util.inspect(responseData, {depth: null}))
                resolve(JSON.parse(responseData))
            });
        });

        req.on('error', (error) => {
            console.error('Error:', error);
            reject({'error' : 'Something went wrong'})
        });

        req.write(data);
        req.end();
    })
    return response
}


async function getBookings(accessKey, accessSecret, fromDate, toDate)
{
    requestMethod = "getbookings"
    timestamp = new Date().toISOString().split(".")[0]
    data = `{
        "hotelogix": {
            "version": "1.0",
            "datetime": "${timestamp}",
            "request": {
                "method": "${requestMethod}",
                "key": "${accessKey}",
                "data": {
                    "fromDate": "${fromDate}",
                    "toDate": "${toDate}",
                    "searchBy": "STAYDATE",
                    "reservationStatus": ["RESERVE", "CHECKIN", "BLOCKED"],
                    "extraDetails": {
                        "Purpose": true,
                        "SalesPerson": true,
                        "CustomTag": true,
                        "CustomFields": true
                    }
                }
            }
        }
    }`
    response = getPostResponse(requestMethod, accessSecret, data)
    return response;
}

accessKey = process.argv[2] || 'tjv8yIULyJ1zPmA'
accessSecret = process.argv[3] || 'NKZLdqRqAJ2YlCa'
fromDate = process.argv[4] || "2023-08-10"
toDate = process.argv[5] || "2023-08-15"
timestamp = new Date().toISOString().split(".")[0]
path = process.argv[6] || `${timestamp}.json`
getBookings(accessKey, accessSecret, fromDate, toDate)
.then((response) => {
    fs.writeFile(path, JSON.stringify(response), (err) => {
        if (err) {
            console.error('Error writing to file:', err);
        } else {
            console.log('Data written to file successfully.');
        }
    });
})
.catch((error) => {
    fs.writeFile(path, JSON.stringify({'error' : 'Something went  wrong'}), (err) => {
        if (err) {
            console.error('Error writing to file:', err);
        } else {
            console.log('Data written to file successfully.');
        }
    });
})
