
&НаСервере
Процедура РасчитатьНаСервере()
	
	РегистрыСведений.СтатистикаПоИнформационнымБазамИтоги.ПересчетИтогов();
	
КонецПроцедуры

&НаКлиенте
Процедура Расчитать(Команда)
	РасчитатьНаСервере();
КонецПроцедуры
