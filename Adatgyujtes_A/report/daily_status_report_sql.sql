SELECT
	U.usr,
	U.subject_id,
	U.status_id,
	(COUNT(ATOT.question_id) + COUNT(EOT.question_id)) AS COUNT_ONETIME
FROM
	(
			hv_user U
		LEFT JOIN
			(
				SELECT
					DISTINCT
					T.question_id,
					T.subject_id
				FROM
					hv_answer_temp T
				INNER JOIN
					hv_questions Q
				ON
					T.question_id = Q.question_id
				WHERE
					Q.type = "One Time"
			) ATOT
		ON
			U.subject_id = ATOT.subject_id
	)
	LEFT JOIN
		(
			SELECT
				DISTINCT
				T.question_id,
				T.subject_id
			FROM
				hv_export T
			INNER JOIN
				hv_questions Q
			ON
				T.question_id = Q.question_id
			WHERE
				Q.type = "One Time"
		) EOT
	ON
		U.subject_id = EOT.subject_id
WHERE
		U.status_id < 60
GROUP BY
	U.usr,
	U.subject_id,
	U.status_id
ORDER BY
	U.subject_id;
-----------------------------------------------------
SELECT
	COUNT(1)
FROM
	hv_questions
WHERE
	type = "One Time";
-----------------------------------------------------
SELECT
	IIF(COUNT(1) = 0 AND {?percent} = 100, "Sleep Diary", "") AS missing_time_str
FROM
	hv_export E
LEFT JOIN
	hv_questions Q
ON
	E.question_id = Q.question_id
WHERE
		Q.type = "Sleep Diary"
	AND CDATE(E.timestamp) > (SELECT DateAdd ( "d", -1, TimeZero) FROM Env)
	AND E.subject_id = "{?subject_id}"
UNION SELECT
	"VAS " + FORMAT(alarm_start, "h:mm am/pm") AS missing_time_str
FROM
	alarms
WHERE
		alarm_finish < (SELECT TimeZero FROM Env)
	AND FORMAT(alarm_start, "yyyy-MM-dd") = (SELECT FORMAT(TimeZero, "yyyy-MM-dd") FROM Env)
	AND notification_enabled = "true"
	AND user = "{?usr}"
	AND {?percent} = 100
UNION ALL SELECT
	"VAS " + FORMAT(alarm_start, "h:mm am/pm") AS missing_time_str
FROM
	hv_missing
WHERE
		alarm_finish < (SELECT TimeZero FROM Env)
	AND FORMAT(alarm_start, "yyyy-MM-dd") = (SELECT FORMAT(TimeZero, "yyyy-MM-dd") FROM Env)
	AND subject_id = "{?subject_id}"
	AND {?percent} = 100
ORDER BY
	missing_time_str
-------------------------------------------------------
SELECT
	IIF(COUNT(1) = 0, "Sleep Diary", "")
FROM
	hv_export E
LEFT JOIN
	hv_questions Q
ON
	E.question_id = Q.question_id
WHERE
		Q.type = "Sleep Diary"
	AND FORMAT(alarm_start, "yyyy-MM-dd") = (SELECT FORMAT(TimeZero, "yyyy-MM-dd") FROM Env)
	AND E.subject_id = "{?subject_id}"

