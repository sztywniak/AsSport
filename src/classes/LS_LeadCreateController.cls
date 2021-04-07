public without sharing class LS_LeadCreateController {
    public String isSurvey { get; set; }
    public String surveydsId { get; set; }
    public LS_LeadCreateController(ApexPages.StandardController stdController) {
        isSurvey = System.currentPageReference().getParameters().get('survey');
    }
}