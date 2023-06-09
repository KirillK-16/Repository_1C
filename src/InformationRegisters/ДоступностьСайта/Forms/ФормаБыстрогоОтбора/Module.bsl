
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Для Каждого ТекЭлемент Из ЭтотОбъект.Список.Отбор.ДоступныеПоляОтбора.Элементы Цикл
		Если ТекЭлемент.Поле = Новый ПолеКомпоновкиДанных("ВыполнятьКонтроль") Тогда
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.Заполнено);
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.НеЗаполнено);
		ИначеЕсли ТекЭлемент.Поле = Новый ПолеКомпоновкиДанных("Доступность") Тогда
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.Заполнено);
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.НеЗаполнено);
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.Содержит);
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.НеСодержит);
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.Подобно);
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.НеПодобно);
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.Больше);
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.БольшеИлиРавно);
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.Меньше);
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.МеньшеИлиРавно);
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.НачинаетсяС);
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.НеНачинаетсяС);
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.ВСписке);
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.НеВСписке);
		ИначеЕсли ТекЭлемент.Поле = Новый ПолеКомпоновкиДанных("ВидРесурса") Тогда
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.Заполнено);
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.НеЗаполнено);
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.Содержит);
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.НеСодержит);
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.Подобно);
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.НеПодобно);
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.Больше);
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.БольшеИлиРавно);
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.Меньше);
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.МеньшеИлиРавно);
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.НачинаетсяС);
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.НеНачинаетсяС);
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.ВСписке);
			УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных.НеВСписке);
		КонецЕсли;
	КонецЦикла;
		
	ЭлементВыполнятьКонтроль = ЭтотОбъект.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементВыполнятьКонтроль.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВыполнятьКонтроль");
	ЭлементВыполнятьКонтроль.Использование = Ложь;
	ЭлементВыполнятьКонтроль.ПравоеЗначение = Истина;
	
	ЭлементДоступность = ЭтотОбъект.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементДоступность.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Доступность");
	ЭлементДоступность.Использование = Ложь;
	ЭлементДоступность.ПравоеЗначение = "Доступен";
	
	ЭлементВидРесурса = ЭтотОбъект.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементВидРесурса.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВидРесурса");
	ЭлементВидРесурса.Использование = Ложь;
	ЭлементВидРесурса.ПравоеЗначение = "Публикация";
	
	Для Каждого ТекЭлемент Из ЭтотОбъект.ПараметрыОткрытия.Элементы Цикл
		Если ТекЭлемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВыполнятьКонтроль") Тогда
			ЭлементВыполнятьКонтроль.Использование = ТекЭлемент.Использование;
			ЭлементВыполнятьКонтроль.ВидСравнения = ТекЭлемент.ВидСравнения;
			ЭлементВыполнятьКонтроль.ПравоеЗначение = ТекЭлемент.ПравоеЗначение;
		ИначеЕсли ТекЭлемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Доступность") Тогда
			ЭлементДоступность.Использование = ТекЭлемент.Использование;
			ЭлементДоступность.ВидСравнения = ТекЭлемент.ВидСравнения;
			ЭлементДоступность.ПравоеЗначение = ТекЭлемент.ПравоеЗначение;
		ИначеЕсли ТекЭлемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВидРесурса") Тогда
			ЭлементВидРесурса.Использование = ТекЭлемент.Использование;
			ЭлементВидРесурса.ВидСравнения = ТекЭлемент.ВидСравнения;
			ЭлементВидРесурса.ПравоеЗначение = ТекЭлемент.ПравоеЗначение;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьДоступныйВидСравнения(ТекЭлемент, ВидСравненияКомпоновкиДанных)
	
	ЭлементУдаления = ТекЭлемент.ДоступныеВидыСравнения.НайтиПоЗначению(ВидСравненияКомпоновкиДанных);
	
	Если ЭлементУдаления <> Неопределено Тогда
		ТекЭлемент.ДоступныеВидыСравнения.Удалить(ЭлементУдаления);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОтборПравоеЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если ЭтотОбъект.Элементы.СписокОтбор.ТекущиеДанные.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Доступность") Тогда
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.Добавить("Доступен");
		ДанныеВыбора.Добавить("Недоступен");
		
		СтандартнаяОбработка = Ложь;
	ИначеЕсли ЭтотОбъект.Элементы.СписокОтбор.ТекущиеДанные.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВидРесурса") Тогда
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.Добавить("Публикация");
		ДанныеВыбора.Добавить("Оборудование (ping)");
		ДанныеВыбора.Добавить("Информационная база");
		
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	ОповеститьОВыборе(ЭтотОбъект.Список.Отбор);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ЭтотОбъект.Параметры.Свойство("Отбор") Тогда
		ЭтотОбъект.ПараметрыОткрытия = ЭтотОбъект.Параметры.Отбор;
	КонецЕсли;
КонецПроцедуры
