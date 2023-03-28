type storage = address

let pay_address ( payee, payment_amount : address * tez ) : operation =
	let payee_contract : unit contract = Tezos.get_contract_with_error payee "ERROR: invalid payee address" in
	Tezos.transaction unit payment_amount payee_contract

let main ( (_, expiry_timestamp), beneficiary : (string * timestamp) * storage ) : (operation list * storage) =
	if Tezos.get_now () > expiry_timestamp then failwith "ERROR: payment expired"
	else
		let payment_amount = Tezos.get_amount () in
		let payment_forward = pay_address ( beneficiary, payment_amount ) in
		[ payment_forward ], beneficiary
