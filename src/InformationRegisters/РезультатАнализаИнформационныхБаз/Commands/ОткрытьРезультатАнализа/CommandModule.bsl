
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	ПараметрыФормы = Новый Структура("Ключ", СоздатьКлючЗаписи(ПараметрКоманды));
	ОткрытьФорму("РегистрСведений.РезультатАнализаИнформационныхБаз.Форма.ФормаЗаписи", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник);
КонецПроцедуры

&НаСервере
Функция СоздатьКлючЗаписи(ИнформационнаяБаза)
	ЗначениеКлюча = Новый Структура("ИнформационнаяБаза", ИнформационнаяБаза);
	КлючЗаписи = РегистрыСведений.РезультатАнализаИнформационныхБаз.СоздатьКлючЗаписи(ЗначениеКлюча);
	Возврат КлючЗаписи;
КонецФункции
