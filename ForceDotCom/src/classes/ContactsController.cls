/* This Controller is used to pull the Contacts and used in VF page 
 *  with Angular JS example
 */
public class ContactsController {
	@RemoteAction
    public static List<Contact> GetAllContactsByFilter(String searchText) {
        String searchString = '%'+ searchText +'%';
        List<Contact> contactList = [Select FirstName, LastName, Phone, Email, Title, Account.Name FROM Contact where FirstName like : searchString];
        return contactList;
    }
}