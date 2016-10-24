#!/usr/bin/python -u

import sys
import smtplib

job_id = sys.argv[1]
sender = sys.argv[2]
password = sys.argv[3]
receivers = sys.argv[4::]

recips = ""
for guy in receivers:
	recips = recips + guy + ","

message = "From: Instrument Control <" + sender + ">" + "\n"
message = message + "To: " + recips + "\n"
message = message + "Subject: Sweep job " + job_id + "\n"

msg = sys.stdin.readline()
while msg:
	message = message + msg
	msg = sys.stdin.readline()

smtpObj = smtplib.SMTP_SSL("smtp.gmail.com", 465)
smtpObj.ehlo(sender)
smtpObj.starttls()
smtpObj.ehlo(sender)
smtpObj.login(sender, password)
failed = smtpObj.sendmail(sender, receivers, message)
if failed:
	smtpObj.close()
	exit(-1)
else:
	smtpObj.close()
	exit(0)
end