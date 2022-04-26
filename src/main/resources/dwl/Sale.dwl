%dw 2.0
output application/json
var shipmentInvoice = flatten(flatten(payload.OriginalPayload.Invoice) filter(["Ready For Publishing"] contains $.PublishStatus.PublishStatusId ) map(inv)->{
	
	Invoice : inv
	
	// flatten((inv) reduce(item, acc -> acc + (item ++ { InvoiceNum : $$})))
} 
) 

var payment = payload.OriginalPayload.Payment

---
shipmentInvoice ++ payment