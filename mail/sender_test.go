package mail

import (
	"testing"

	"github.com/stretchr/testify/require"
	"github.com/techschool/simplebank/util"
)

func TestSendEmailWithGmail(t *testing.T) {
	if testing.Short() {
		t.Skip("Skipping test in short mode.")
	}

	config, err := util.LoadConfig("..")

	require.NoError(t, err)
	sender := NewGmailSender(
		config.EmailSenderAddress,
		config.EmailSenderUsername,
		config.EmailSenderPassword,
	)

	subject := "A test email"
	content := "<h1>This is a test email sent from Simple Bank</h1>"
	to := []string{"techschool.guru@gmail.com"}

	attachFiles := []string{"../README.md"}

	err = sender.SendEmail(subject, content, to, nil, nil, attachFiles)
	require.NoError(t, err)
}
