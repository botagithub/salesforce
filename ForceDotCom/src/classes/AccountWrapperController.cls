public class AccountWrapperController {
    public List<AccountWrapper> displayList{get;set;}
    public List<String> currentList = new List<String>();
    public List<String> nextList = new List<String>();
    public List<String> previousList = new List<String>();
    Integer listSize = 5;
    
    //Constructor
    public AccountWrapperController() {
        Integer record_counter = 0;
        for(Account a : [Select Id FROM Account ORDER BY Name LIMIT 1000]) {
            if(record_counter < listSize) {
                currentList.add(a.Id);
            } else {
                nextList.add(a.Id);
            }
            record_counter++;
        }
    }
    
    public List<AccountWrapper> getRecordsToDisplay() {
        Set<String> record_ids = new Set<String>();
        Boolean record_added = record_ids.addAll(currentList);
        displayList = new List<AccountWrapper>();
        Integer counter = 1;
        for(Account a : [Select AccountNumber, Id, Name, OwnerId, Phone, Site, Type FROM Account WHERE id IN : record_ids order by Name])
        {
            displayList.add(new AccountWrapper(a,counter));
            counter++;
        }
        return displayList;
    }
    
    //Wrapper Class
    public class AccountWrapper {
        public Account act{get;set;}
        public Integer numberOfRow{get;set;}
        
        public AccountWrapper(Account a, Integer rowCounter) {
            this.act = a;
            this.numberOfRow = rowCounter;
        }
    }
    
    public Integer getCurrentSize() {
        return currentList.size();
    }
    
    public Integer getPrevSize() {
        return previousList.size();
    }
    
    public Integer getNextSize() {
        return nextList.size();
    }
}