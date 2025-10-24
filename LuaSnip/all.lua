---@diagnostic disable: undefined-global

return {
	s("date", t(os.date("%Y/%m/%d"))),
	s("mail", t("v.e.apostol@proton.me")),
	s("(", { t("("), i(1), t(")") }),
	s("[", { t("["), i(1), t("]") }),
	s("{", { t("{"), i(1), t("}") }),
	s("$", { t("$"), i(1), t("$") }),


	s({ trig = "mt", snippetType = "autosnippet" },
		fmta("$<>$", { i(1) })
	),
}
