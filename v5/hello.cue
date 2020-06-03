// V5: let's deploy that html to Netlify and S3!

package main

doc: #HelloDocument
website: contents: doc.htmlDir
s3bucket: source: doc.htmlDir
