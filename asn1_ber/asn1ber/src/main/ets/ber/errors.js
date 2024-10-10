export const  Errors= {
	InvalidAsn1Error: function(msg) {
		var e = new Error()
		e.name = 'InvalidAsn1Error'
		e.message = msg || ''
		return e
	}
}
