public class AppLoggingDetails
    {
        public long LogId { get; set; }
        public DateTime? TransactionDate { get; set; }
        public string UserName { get; set; }
        public int? Action { get; set; }
        public string ModelObject { get; set; }
        public string KeyName { get; set; }
        public string KeyValue { get; set; }
        public string KeyName1 { get; set; }
        public string KeyValue1 { get; set; }
        public string ValueName1 { get; set; }
        //public string Description { get; set; }
        public string PropertyName { get; set; }
        public string OldValue { get; set; }
        public string NewValue { get; set; }
        public Guid AppTransactionLogId { get; set; }
        public DateTime? CreateDate { get; set; }
        public string Description
        {
            get => (Action) switch
            {
                3 => $"{ValueName1} {(PropertyName == "Active" ? "" : PropertyName)}  was updated  " +
                            $"from {OldValue.Replace("True", "Enabled").Replace("False", "Disabled")} " +
                            $"to {NewValue.Replace("True", "Enabled").Replace("False", "Disabled")} in {ModelObject}",
                4 => $"{ValueName1 ?? "New Record"} {PropertyName}  was added  in {ModelObject}",
                _ => "An Error Occured"
            };

        }

    }
}