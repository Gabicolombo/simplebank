package mail

import (
	"fmt"
	"net/smtp"

	"github.com/jordan-wright/email"
)

const (
	smtpAuthAddress   = "sandbox.smtp.mailtrap.io"
	smtpServerAddress = "sandbox.smtp.mailtrap.io:587"
)

type EmailSender interface {
	SendEmail(subject string, content string, to []string, cc []string, bcc []string, attachFiles []string) error
}

type GmailSender struct {
	name              string
	fromEmailAddress  string
	fromEmailUsername string
	fromEmailPassword string
}

func NewGmailSender(name string, fromEmailAddress string, fromEmailUsername string, fromEmailPassword string) *GmailSender {
	return &GmailSender{
		name:              name,
		fromEmailAddress:  fromEmailAddress,
		fromEmailUsername: fromEmailUsername,
		fromEmailPassword: fromEmailPassword,
	}
}

func (sender *GmailSender) SendEmail(subject string,
	content string,
	to []string,
	cc []string,
	bcc []string,
	attachFiles []string,
) error {
	e := email.NewEmail()
	e.From = fmt.Sprintf("%s <%s>", sender.name, sender.fromEmailAddress)
	e.Subject = subject
	e.HTML = []byte(content)
	e.To = to
	e.Cc = cc
	e.Bcc = bcc

	for _, file := range attachFiles {
		_, err := e.AttachFile(file)
		if err != nil {
			return fmt.Errorf("Failed to attach file %s: %w", file, err)
		}
	}

	smtpAuth := smtp.PlainAuth("",
		sender.fromEmailUsername,
		sender.fromEmailPassword,
		smtpAuthAddress,
	)
	return e.Send(smtpServerAddress, smtpAuth)
}
