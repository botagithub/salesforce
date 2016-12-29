public class ActionFunctionSearchController {
	//the search results
    public List<Account> results{get;set;}
    
    //Search text entered by Use
    public String searchStr{get;set;}
    
    //Constructor
    public ActionFunctionSearchController() {
        results = new List<Account>();
    }
    
    //executes the search
    public PageReference doSearch() {
        String wcStr = '%'+searchStr+'%';
        results = [Select Id, Name, Type, Industry FROM Account where name like :wcStr];
        
        return null;
    }
    
    //Action method to clear down the list of results
    public PageReference clearResults() {
        results.clear();
        
        return null;
    }
    
    //getter to indicate if there are results available
    public Boolean getresultsAvailable() {
        return (results.size() > 0);
    }
}