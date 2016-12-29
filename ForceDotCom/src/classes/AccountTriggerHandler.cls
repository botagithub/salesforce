public class AccountTriggerHandler {
    List<Account> newAccs;
    List<Account> oldAccs;
    Map<Id,Account> newAccMap;
    Map<Id,Account> oldAccMap;
    
    List<Contact> newIds = new List<Contact>();
    List<Account> acccLst = new List<Account>();
    Set<Id> accSet = new Set<Id>();
    
    public AccountTriggerHandler (List<Account> newAccs, List<Account> oldAccs,Map<Id,Account> newAccMap, Map<Id,Account> oldAccMap){
        this.newAccs = newAccs;
        this.oldAccs = oldAccs;
        this.newAccMap = newAccMap;
        this.oldAccMap = oldAccMap;
    }
    
    public void handleBeforeInsert() {
        validateAccountForCreate();
        checkDuplicateAccountName();
    }
    
    public void handlerBeforeDelete() {
        System.debug('@@@ Trigger.new is = '+oldAccs);
        validateAccountForDelete();
        preventAccountDeleteWithContact();
    }
    
    public void handleAfterInsert() {
        validateSubscribedChk();
    }
    
    private void validateAccountForDelete() {
         for(Account currAccount : oldAccs) {
            if (currAccount.Account_Status__c != 'OkToDelete') {
                currAccount.addError('Account can\'t be deleted.');
            }
        }
    }
    
    private void preventAccountDeleteWithContact() {
        for(Account acc : oldAccs) {
            accSet.add(acc.Id);
        }
        map<id, account> accMap = new map<id,account>([Select id, (Select id from Contacts) FROM Account where Id IN : accSet]);
        for(Account acc : oldAccs) {
            if(accMap.get(acc.id).contacts.size() > 0) {
                acc.addError('Account having Contacts cannot be deleted');
            }
        }
    }
    private void validateAccountForCreate() {
        for(Account ac : newAccs) {
            if(ac.Name == 'Salesforce') {
                ac.Name.addError('Account Name can\'t be Salesforce');
            } else if (ac.AnnualRevenue==null){
                ac.AnnualRevenue.addError('Annual Revenue is Required');
            }
        }
    }
    
    private void checkDuplicateAccountName() {
        List<Id> accsId = new List<Id>();
        Map<id,Account> accMap = new Map<id,Account>([Select Id, Name From Account ]);
         for(Account acc : newAccs) {
           accsId.add(acc.Id);
        }
        system.debug('@@@@###'+accMap);
        for(Account acc : [Select id, name FROM Account where Id IN :accsId]) {
            System.debug('@@@ Name 1 :- '+acc.name);
            System.debug('@@@ Name 2 :- '+accMap.get(acc.Id).Name);
            if(acc.name == accMap.get(acc.Id).Name) {
                acc.Name.addError('Account Name cannot be Duplicate with Account Id :-'+accMap.get(acc.Id));
            }
        }
    }
    
    private void validateSubscribedChk() {
        for(Account account: newAccs) {
            Account oldAccId = oldAccMap.get(account.Id);
            if((oldAccId.Subscribed__c != account.Subscribed__c) && (account.Subscribed__c == true || account.Subscribed__c == false)) {
                List<Contact> conList = [Select Id, AccountId, Subscribed__c From Contact Where AccountId =: account.Id];
                System.debug('@@@ Contact List-->'+conList);
                for(Contact c : conList) {
                    if(c.Subscribed__c != account.Subscribed__c) {
                        c.Subscribed__c = account.Subscribed__c;
                        newIds.add(c);
                    }
                }
            }
        }
        System.debug('@@@  List to Update -->'+newIds);
        if(!newIds.isEmpty()) {
            System.debug('I am Here');
            update newIds;
        }
    }
    
}