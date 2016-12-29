public class OpportunityTriggerHandler {
    List<Opportunity> newOpps;
    List<Opportunity> oldOpps;
    Map<Id, Opportunity> newOppMap;
    Map<Id, Opportunity> oldOppMap;
    
    List<Id > campIds = new List<Id>();
    List<Id> oppIds = new List<Id>();
    List<Campaign> CampListToUpdate = new List<Campaign>();
    Map<Id,Double> delOppMap = new Map<Id,Double>();
    Map<Id, Campaign> mapCampaigns; //= new Map<Id, Campaign>();
    //Constructor
    public OpportunityTriggerHandler(List<Opportunity> newOpps, List<Opportunity> oldOpps, Map<Id, Opportunity> newOppMap, Map<Id, Opportunity> oldOppMap) {
        this.newOpps = newOpps;
        this.oldOpps = oldOpps;
        this.newOppMap = newOppMap;
        this.oldOppMap = oldOppMap;
    }
    
    public void handleAfterInsert() {
        rollupCampaignAmount();
    }
    
    public void handleAfterUpdate() {
        rollupCampaignAmount();
    }
    
    public void handleAfterDelete() {
        removeCampaignAmount();
    }
    
    private void rollupCampaignAmount() {
        for(Opportunity opp : newOpps) {
            if(opp.CampaignId != null && (trigger.isInsert || opp.Amount_Received__c != oldOppMap.get(opp.Id).Amount_Received__c)) {
                campIds.add(opp.CampaignId);
            }
        }
        
        //Logic for Add or Update
        if(campIds.size() > 0) {
            mapCampaigns = new Map<Id, Campaign>([Select Id FROM Campaign Where Id=: campIds]);
            System.debug('@@@ mapCampaigns in Create/Update-->'+mapCampaigns);
            // initilize Campaign.Total_Amount_Received__c to zero on all campaigns
            for(Campaign c : mapCampaigns.values()) {
                c.Total_Amount_Received__c = 0;
            }
            for(Opportunity op : [Select Id, Amount_Received__c, CampaignId FROM Opportunity WHERE CampaignId =: campIds]) {
                Campaign c = mapCampaigns.get(op.CampaignId);
                c.Total_Amount_Received__c += op.Amount_Received__c;
            }
        }
        update mapCampaigns.values();
    }
    
    private void removeCampaignAmount() {
        for(Opportunity oldOpp : oldOpps) {
            if(oldOpp.CampaignId != null) {
                campIds.add(oldOpp.CampaignId);           
            }
        }
        System.debug('@@@ Old Opp\'s Campign Ids-->'+campIds);
        //Logic for Delete 
        if(campIds.size() > 0) {
            mapCampaigns = new Map<Id, Campaign>([Select Id,Total_Amount_Received__c FROM Campaign Where Id=: campIds]);
            System.debug('@@@ mapCampaigns in Delete-->'+mapCampaigns);
            
            for(Opportunity op : oldOpps) {
                Campaign c = mapCampaigns.get(op.CampaignId);
                System.debug('@@@ Total Campaign Amount= '+c.Total_Amount_Received__c);
                System.debug('@@@ Opp to remove = '+op.Amount_Received__c);
                c.Total_Amount_Received__c = c.Total_Amount_Received__c - op.Amount_Received__c;
                CampListToUpdate.add(c);
            }
        }
        
        update CampListToUpdate;
    }
}