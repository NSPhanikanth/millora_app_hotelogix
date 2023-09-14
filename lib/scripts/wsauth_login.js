// npm install crypto-js

const https = require('https');
const util = require('util')
var CryptoJS = require("crypto-js");
const fs = require('fs');

let errorResponse = {"hotelogix":{"version":"1.0","datetime":"2023-08-22T13:59:15","response":{"status":{"code":5000,"message":"Something went wrong"}}}}

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
                test_resp = JSON.parse(responseData)
                resolve(test_resp)
            });
        });

        req.on('error', (error) => {
            console.error('Error:', error);
            resolve({'error' : 'Something went wrong'})
        });

        req.write(data);
        req.end();
    })
    return response;
}


async function getAccessSecret(accessKey, accessSecret)
{
    timestamp = new Date().toISOString().split(".")[0]
    data = `{
        "hotelogix": {
            "version": "1.0",
            "datetime": "${timestamp}",
            "request": {
                "method": "wsauth",
                "key": "${accessKey}"
            }
        }
    }`
    response = getPostResponse('wsauth', accessSecret, data);
    return response
}

async function login(accessKey, accessSecret, hotelId, counterId, email, password)
{
    requestMethod = "login"
    timestamp = new Date().toISOString().split(".")[0]
    data = `{
        "hotelogix": {
            "version": "1.0",
            "datetime": "${timestamp}",
            "request": {
                "method": "${requestMethod}",
                "key": "${accessKey}",
                "data": {
                    "hotelId": "${hotelId}",
                    "counterId": "${counterId}",
                    "email": "${email}",
                    "password": "${password}",
                    "forceOpenCouner": true,
                    "forceLogin": true
                }
            }
        }
    }`
    response = getPostResponse(requestMethod, accessSecret, data)
    return response;
}

accessTokenRequired = (process.argv[2] == 'true')
consumerKey = process.argv[3] || 'D401B02273AD373F95518848C5288572F073A07E'
consumerSecret = process.argv[4] || '3DD5CDF28FE6B6DD47A9AE9BF011AE935E0065B3'
hotelId = process.argv[5] || '21743'
counterId = process.argv[6] || 'eWtyaWk3TFpxbXc9'
email = process.argv[7] || 'api@hotelogix.user'
password = process.argv[8] || 'password'
path = process.argv[9] || `${timestamp}.json`


if(accessTokenRequired)
{
    getAccessSecret(consumerKey, consumerSecret)
    .then((response) => {
        console.log('WSAUTH Response:');
        console.log(util.inspect(response, {depth: null}))
        try{
            // accessKey = response['hotelogix']['response']['accesskey'];
            // accessSecret = response['hotelogix']['response']['accesssecret'];
            login(consumerKey, consumerSecret, hotelId, counterId, email, password)
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
                    fs.writeFile(path, JSON.stringify(errorResponse), (err) => {
                        if (err) {
                            console.error('Error writing to file:', err);
                        } else {
                            console.log('Data written to file successfully.');
                        }
                    });
                })
            }
        catch
        {
            fs.writeFile(path, JSON.stringify(errorResponse), (err) => {
                if (err) {
                    console.error('Error writing to file:', err);
                } else {
                    console.log('Data written to file successfully.');
                }
            });
        }
    })
    .catch((error) => {
        fs.writeFile(path, JSON.stringify(errorResponse), (err) => {
            if (err) {
                console.error('Error writing to file:', err);
            } else {
                console.log('Data written to file successfully.');
            }
        });
    });
}
else
{
    login(consumerKey, consumerSecret, hotelId, counterId, email, password)
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
        fs.writeFile(path, JSON.stringify(errorResponse), (err) => {
            if (err) {
                console.error('Error writing to file:', err);
            } else {
                console.log('Data written to file successfully.');
            }
        });
    })
}
