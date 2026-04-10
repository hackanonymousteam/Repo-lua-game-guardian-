local chat = gg.prompt({'Enter number'}, {}, {'text'})
if chat == nil then
    return
end
local user_number = tonumber(chat[1]) 

local sph = gg.prompt({
 "United States Dollar",
 "United Arab Emirates Dirham",
 "Afghan Afghani",
 "Albanian Lek",
 "Armenian Dram",
 "Netherlands Antillean Guilder",
 "Angolan Kwanza",
 "Argentine Peso",
 "Australian Dollar",
 "Aruban Florin",
 "Azerbaijani Manat",
 "Bosnia-Herzegovina Convertible Mark",
 "Barbadian Dollar",
 "Bangladeshi Taka",
 "Bulgarian Lev",
 "Bahraini Dinar",
 "Burundian Franc",
 "Bermudian Dollar",
 "Brunei Dollar",
 "Bolivian Boliviano",
 "Brazilian Real",
 "Bahamian Dollar",
 "Bhutanese Ngultrum",
 "Botswana Pula",
 "Belarusian Ruble",
 "Belize Dollar",
 "Canadian Dollar",
 "Congolese Franc",
 "Swiss Franc",
 "Chilean Peso",
 "Chinese Yuan",
 "Colombian Peso",
 "Costa Rican Colón",
 "Cuban Peso",
 "Cape Verdean Escudo",
 "Czech Koruna",
 "Djiboutian Franc",
 "Danish Krone",
 "Dominican Peso",
 "Algerian Dinar",
 "Egyptian Pound",
 "Eritrean Nakfa",
 "Ethiopian Birr",
 "Euro",
 "Fijian Dollar",
 "Falkland Islands Pound",
 "Faroe Islands Krone",
 "British Pound",
 "Georgian Lari",
 "Guernsey Pound",
 "Ghanaian Cedi",
 "Gibraltar Pound",
 "Gambian Dalasi",
 "Guinean Franc",
 "Guatemalan Quetzal",
 "Guyanese Dollar",
 "Hong Kong Dollar",
 "Honduran Lempira",
 "Croatian Kuna",
 "Haitian Gourde",
 "Hungarian Forint",
 "Indonesian Rupiah",
 "Israeli New Shekel",
 "Isle of Man Pound",
 "Indian Rupee",
 "Iraqi Dinar",
 "Iranian Rial",
 "Icelandic Króna",
 "Jersey Pound",
 "Jamaican Dollar",
 "Jordanian Dinar",
 "Japanese Yen",
 "Kenyan Shilling",
 "Kyrgyzstani Som",
 "Cambodian Riel",
 "Kiribati Dollar",
 "Comorian Franc",
 "South Korean Won",
 "Kuwaiti Dinar",
 "Cayman Islands Dollar",
 "Kazakhstani Tenge",
 "Lao Kip",
 "Lebanese Pound",
 "Sri Lankan Rupee",
 "Liberian Dollar",
 "Lesotho Loti",
 "Libyan Dinar",
 "Moroccan Dirham",
 "Moldovan Leu",
 "Malagasy Ariary",
 "Macedonian Denar",
 "Myanma Kyat",
 "Mongolian Tögrög",
 "Macanese Pataca",
 "Mauritanian Ouguiya",
 "Mauritian Rupee",
 "Maldivian Rufiyaa",
 "Malawian Kwacha",
 "Mexican Peso",
 "Malaysian Ringgit",
 "Mozambican Metical",
 "Namibian Dollar",
 "Nigerian Naira",
 "Nicaraguan Córdoba",
 "Norwegian Krone",
 "Nepalese Rupee",
 "New Zealand Dollar",
 "Omani Rial",
 "Panamanian Balboa",
 "Peruvian Sol",
 "Papua New Guinean Kina",
 "Philippine Peso",
 "Pakistani Rupee",
 "Polish Złoty",
 "Paraguayan Guaraní",
 "Qatari Riyal",
 "Romanian Leu",
 "Serbian Dinar",
 "Russian Ruble",
 "Rwandan Franc",
 "Saudi Riyal",
 "Solomon Islands Dollar",
 "Seychellois Rupee",
 "Sudanese Pound",
 "Swedish Krona",
 "Singapore Dollar",
 "Saint Helena Pound",
 "Sierra Leonean Leone",
 "Somali Shilling",
 "Surinamese Dollar",
 "South Sudanese Pound",
 "São Tomé and Príncipe Dobra",
 "Syrian Pound",
 "Swazi Lilangeni",
 "Thai Baht",
 "Tajikistani Somoni",
 "Turkmenistani Manat",
 "Tunisian Dinar",
 "Tongan Paʻanga",
 "Turkish Lira",
 "Trinidad and Tobago Dollar",
 "Tuvaluan Dollar",
 "New Taiwan Dollar",
 "Tanzanian Shilling",
 "Ukrainian Hryvnia",
 "Ugandan Shilling",
 "Uruguayan Peso",
 "Uzbekistani So'm",
 "Venezuelan Bolívar",
 "Vietnamese Dong",
 "Vanuatu Vatu",
 "Samoan Tālā",
 "Central African CFA Franc",
 "East Caribbean Dollar",
 "Special Drawing Rights",
 "West African CFA Franc",
 "CFP Franc",
 "Yemeni Rial",
 "South African Rand",
 "Zambian Kwacha",
 "Zimbabwean Dollar"

}, {false, false, false, false, false, false, false, false, false, false,
 false, false, false, false, false, false, false, false, false, false,
 false, false, false, false, false, false, false, false, false, false,
 false, false, false, false, false, false, false, false, false, false,
 false, false, false, false, false, false, false, false, false, false,
 false, false, false, false, false, false, false, false, false, false,
 false, false, false, false, false, false, false, false, false, false,
 false, false, false, false, false, false, false, false, false, false,
 false, false, false, false, false, false, false, false, false, false,
 false, false, false, false, false, false, false, false, false, false,
 false, false, false, false, false, false, false, false, false, false,
 false, false, false, false, false, false, false, false, false, false,
 false, false, false, false, false, false, false, false, false, false,
 false, false, false, false, false, false, false, false, false, false,
 false, false, false, false, false, false, false, false, false, false,
 false, false, false, false, false, false, false, false, false, false,
 false, false, false, false, false, false, false, false, false, false,
 false, false, false, false, false, false, false, false, false, false,
 false, false, false, false, false, false, false, false, false, false,
 false, false, false, false, false, false, false, false, false, false,
 false, false, false, false, false, false, false, false, false, false,
 false, false, false, false, false, false, false, false, false, false,
 false, false, false, false, false, false, false, false, false, false,
 false, false, false, false, false, false, false, false, false, false,
 false, false, false, false, false, false, false, false, false, false
}  , {
    "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", 
    "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox",
    "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox",
    "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox",
    "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox",
    "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox",
    "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox",
    "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox",
    "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox",
    "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox",
    "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox",
    "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox",
    "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox",
    "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox",
    "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox",
    "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox", "checkbox",
    "checkbox"
})

if sph == nil then
    return
end

local block_country_codes = {}
local country_codes = {"USD", "AED", "AFN", "ALL", "AMD", "ANG", "AOA", "ARS", "AUD", "AWG", "AZN", 
"BAM", "BBD", "BDT", "BGN", "BHD", "BIF", "BMD", "BND", "BOB", "BRL", "BSD", 
"BTN", "BWP", "BYN", "BZD", "CAD", "CDF", "CHF", "CLP", "CNY", "COP", "CRC", 
"CUP", "CVE", "CZK", "DJF", "DKK", "DOP", "DZD", "EGP", "ERN", "ETB", "EUR", 
"FJD", "FKP", "FOK", "GBP", "GEL", "GGP", "GHS", "GIP", "GMD", "GNF", "GTQ", 
"GYD", "HKD", "HNL", "HRK", "HTG", "HUF", "IDR", "ILS", "IMP", "INR", "IQD", 
"IRR", "ISK", "JEP", "JMD", "JOD", "JPY", "KES", "KGS", "KHR", "KID", "KMF", 
"KRW", "KWD", "KYD", "KZT", "LAK", "LBP", "LKR", "LRD", "LSL", "LYD", "MAD", 
"MDL", "MGA", "MKD", "MMK", "MNT", "MOP", "MRU", "MUR", "MVR", "MWK", "MXN", 
"MYR", "MZN", "NAD", "NGN", "NIO", "NOK", "NPR", "NZD", "OMR", "PAB", "PEN", 
"PGK", "PHP", "PKR", "PLN", "PYG", "QAR", "RON", "RSD", "RUB", "RWF", "SAR", 
"SBD", "SCR", "SDG", "SEK", "SGD", "SHP", "SLE", "SLL", "SOS"
}
local selected_currency = nil

for i, selected in ipairs(sph) do
    if selected then
        table.insert(block_country_codes, country_codes[i])
        selected_currency = country_codes[i] 
    end
end

if not selected_currency then
    print("select please.")
    return
end

local request = gg.makeRequest('https://open.er-api.com/v6/latest/USD')
local response = request.content

local pattern = '"' .. selected_currency .. '":([%d%.]+)'

local currency_value = response:match(pattern)

if currency_value then
    currency_value = tonumber(currency_value) 
   
 print('value  ' .. selected_currency .. ': ' .. currency_value)

    local result = user_number * currency_value
    gg.alert(user_number .. ' dollars equivalent to ' .. result .. ' ' .. selected_currency)
    print(user_number .. ' dollars equivalent to ' .. result .. ' ' .. selected_currency)
else
    print('no found')
end