public with sharing class MyCustomLookupController {
    public Contact contact{get;set;}
    
    //Constructor
    public MyCustomLookupController() {
        contact = new Contact();
    }
}