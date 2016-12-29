public class ActionFunctionController {
	//Constructor
    public List<Case> getCaseList() {
   		return [select id, CaseNumber, Status, Account.Name from Case order by CreatedDate limit 10];     
    }
    
    //Action method to nevigate to the cases standard tab
    public PageReference goCasesTab() {
        PageReference result=new PageReference('/500/o');
		return result;
    }
}