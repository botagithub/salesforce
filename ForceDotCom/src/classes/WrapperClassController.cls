public class WrapperClassController {
    public List<cContact> contactList{get;set;}
    
    public List<cContact> getContacts() {
        if(contactList == null) {
            contactList = new List<cContact>();
            for(Contact c: [Select Id, Name, Email, Phone FROM Contact Limit 10]) {
                contactList.add(new cContact(c));
            }
        }
        return contactList;
    }
    
    public PageReference processSelected() {
        List<Contact> selectedContacts = new List<Contact>();
        for(cContact cCon: getContacts()) {
            if(cCon.Selected == true) {
                selectedContacts.add(cCon.con);
            }         
        }
        System.debug('There are the Selected Contacts...');
        for(Contact con: selectedContacts) {
            System.debug(con);
        }
        contactList = null;
        return null;
    }
    
    public class cContact {
        public Contact con {get;set;}
        public Boolean selected {get;set;}
        
        public cContact(Contact c) {
            con = c;
            selected = false;
        }
    }
}