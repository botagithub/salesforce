public class ShowParentChild {
    private ApexPages.StandardController controller {get; set;}
    private Account accountRecord {get;set;}
    private List<Account> accountRecords {get;set;}
    private Map<Id, List<Contact>> account_contact_Map {get;set;}
    
    private Id CurrentUser {get;set;}
    public Id accIdChosen {get; set;}
    
    //Constructor
    public ShowParentChild(ApexPages.StandardController controller) {
    
        this.controller = controller;
        CurrentUser = UserInfo.getUserId();
        
        account_contact_Map = new Map<Id, List<Contact>>();
        
        accountRecord = (Account)controller.getRecord();
        accountRecords = [select Id,name, type, phone from Account LIMIT 20];
        
        // this cycle may exceed SOQL queries limit. Consider othe solutions to query contacts
        for (Account acc : accountRecords){
            List<Contact> AllMassiveOppItems = [select firstname, lastname, phone, email
                                                from Contact where accountId = :acc.id];
            
            account_contact_Map.put(acc.id, AllMassiveOppItems);
        }
        accIdChosen = accountRecords[0].id;         
    }
    
    public List<Account> getAccountRecords(){
        return accountRecords;
    }
    
    public List<Contact> getRelatedContactRecords (){
        return account_contact_Map.get(accIdChosen);
    }

}