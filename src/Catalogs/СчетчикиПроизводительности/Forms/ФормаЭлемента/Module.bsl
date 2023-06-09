
&НаСервереБезКонтекста
Функция ЗаполнитьПоШаблонуНаСервере(Ссылка)
	Возврат Справочники.СчетчикиПроизводительности.ПолучитьШаблонПредопределенного(Ссылка);
КонецФункции

&НаКлиенте
Процедура ЗаполнитьПоШаблону(Команда)
	ШаблонЭлемента = ЗаполнитьПоШаблонуНаСервере(Объект.Ссылка);
	
	Если ШаблонЭлемента <> Неопределено Тогда
		Объект.Наименование = ШаблонЭлемента["Наименование"];
		Объект.Описание = ШаблонЭлемента["Описание"];
		
		Объект.НациональноеПредставление.Очистить();
		Для Каждого ТекЯзык Из ШаблонЭлемента["Языки"] Цикл
			НовСтрока = Объект.НациональноеПредставление.Добавить();
			НовСтрока.Язык = ТекЯзык.Ключ;
			НовСтрока.НаименованиеНациональное = ТекЯзык.Значение;
		КонецЦикла;
		
		ЭтотОбъект.Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЭтотОбъект.Элементы.ФормаЗаполнитьПоШаблону.Видимость = Объект.Ссылка.Предопределенный;
КонецПроцедуры
