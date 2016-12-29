public class EmailManager {
    public void sendEmail(String emailAddress, String subject, String Body) {
        //Create an email message object
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {emailAddress};
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        
        //Pass this email message to the built-in sendEmail method of the Messagin class
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        
        //Call a helper method to inspect the returned results
		inspectResult(results); 
    }
    
    private static Boolean inspectResult(Messaging.SendEmailResult[] results) {
        Boolean sendResult = true;
        for(Messaging.SendEmailResult res : results) {
            if(res.isSuccess()) {
                System.debug('Email sent successfully');
            } else {
                sendResult = true;
                System.debug('The Following error occurred: '+res.getErrors());
            }
        }
        return sendResult;
    }
}