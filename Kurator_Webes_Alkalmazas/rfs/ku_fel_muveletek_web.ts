//# server program ku_fel_muveletek_web for form ku_fel_muveletek_web
{
	let rList = [];
	for	(let row of form.tblTovabbiCimzettek.rows) {
		rList.Add(row.taCimzett.text);
	}

	smtp.SendEmail({
		recipients: rList,
		subject: form.targy.text + " " + form.dpHatarIdo.date.Format(dtf.Parse("yyyy\".\"MM\".\"dd")),
		body: form.szoveg.text,
		html: false
	});
}
