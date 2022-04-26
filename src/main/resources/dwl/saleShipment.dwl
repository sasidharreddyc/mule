%dw 2.0
output application/json
var Invoice = payload.OriginalPayload.Invoice

var paymentTransactionDetails = flatten(flatten(payload.OriginalPayload.Payment) map(pay,ind_pay)-> {
	(do{
		var payment = pay - 'PaymentMethod'
		---
		PaymentMethod: pay.PaymentMethod map(pmethod,ind_pm)-> {
			(do {
				var paymentMethod = pmethod - 'PaymentTransaction'
				---
				PaymentTransactions : pmethod.PaymentTransaction map(ptran,ind_pt)-> {
					(do{
						var paymentTransactions = ptran - 'PaymentTransactionDetail'
						---
						PaymentTransactionDetails : ptran.PaymentTransactionDetail reduce(item, acc=[])->acc+(item
							++ {PaymentTransactions : paymentTransactions}
							++ {PaymentMethod:paymentMethod}
							++ {payment:payment}
						)
					})
				}
			})
		}	
	})
	
})..*PaymentTransactionDetails

//fun invoiceById(id) = payload.OriginalPayload.Invoice (filter($.InvoiceId) == id)
var InvoiceId = Invoice.InvoiceId
var paymentTransactionDetailsByInvId = flatten(paymentTransactionDetails) filter($.ReferenceId contains InvoiceId)



//var paymentTransactionDetailsFilter =  paymentTransactionDetails filter(payload.OriginalPayload.Invoice.InvoiceId contains '16463008966397783540')
---
"data" : flatten(paymentTransactionDetailsByInvId)
//flatten(payload.OriginalPayload.Invoice)