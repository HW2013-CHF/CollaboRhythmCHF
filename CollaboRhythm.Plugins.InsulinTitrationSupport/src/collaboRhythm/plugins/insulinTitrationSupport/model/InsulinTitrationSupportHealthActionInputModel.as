package collaboRhythm.plugins.insulinTitrationSupport.model
{
	import collaboRhythm.plugins.schedule.shared.model.HealthActionInputModelBase;
	import collaboRhythm.plugins.schedule.shared.model.IHealthActionModelDetailsProvider;
	import collaboRhythm.shared.model.healthRecord.document.ScheduleItemOccurrence;

	public class InsulinTitrationSupportHealthActionInputModel extends HealthActionInputModelBase
	{
		private var _decisionScheduleItemOccurrence:ScheduleItemOccurrence;

		public function InsulinTitrationSupportHealthActionInputModel(scheduleItemOccurrence:ScheduleItemOccurrence = null, decisionScheduleItemOccurrence:ScheduleItemOccurrence = null,
																	  healthActionModelDetailsProvider:IHealthActionModelDetailsProvider = null)
		{
			super(scheduleItemOccurrence, healthActionModelDetailsProvider);
			_decisionScheduleItemOccurrence = decisionScheduleItemOccurrence;
		}

		public function prepareChartsForDecision():void
		{
			//TODO: I have not been able to reproduce it, but the record was null once
			healthActionModelDetailsProvider.record.healthChartsModel.prepareForDecision("Health Charts - Insulin Titration", decisionScheduleItemOccurrence);
		}

		public function showCharts():void
		{
			healthActionModelDetailsProvider.navigationProxy.showFullView("Health Charts");
		}

		public function get decisionScheduleItemOccurrence():ScheduleItemOccurrence
		{
			return _decisionScheduleItemOccurrence;
		}
	}
}
