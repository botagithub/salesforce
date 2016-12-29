public with sharing class EditFromSearchController 
{
	// the accounts to be edited
	public List<Account> accs {get; set;}
	
	// constructor - extracts account* parameters from the URL and
	// retrieves the associated account records
	public EditFromSearchController()
	{
		List<Id> ids=new List<Id>();
		Integer idx=1;
		String accStr;
		
		// extract indexed parameters from the URL, stopping when null is retrieved
		do 
		{
			accStr=ApexPages.currentPage().getParameters().get('account' + idx);
			if (accStr!=null)
			{
				ids.add(accStr);
			}
			idx++;
		}
		while (null!=accStr);
		
		// if parameters were present, extract the associated accounts
		if (ids.size()>0)
		{
			accs=[select id, Name, Industry, Type from Account where id in :ids];
		}
	}
	
	// saves the account records and redirects to the accounts tab
	public PageReference save()
	{
		update accs;
		
		return new PageReference('/001/o');
	}
}