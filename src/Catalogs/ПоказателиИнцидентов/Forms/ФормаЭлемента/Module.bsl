////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтотОбъект.Параметры.СсылкаНового = Новый Структура;
	
	Если ЭтотОбъект.Параметры.Свойство("ЭтоНовый") И ЭтотОбъект.Параметры.ЭтоНовый И НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЭтотОбъект.ЭтоНовый = Истина;
		
		Объект.Владелец = ЭтотОбъект.Параметры.Владелец;
		Объект.Функция = Перечисления.ФункцииОповещений.Максимум;
		Объект.ИнтервалРасчета = 60;
		Объект.ЕдиницаВремениИнтервалаРасчета = Перечисления.ЕдиницыВремени.Секунда;
		Объект.ВидСравнения = Перечисления.ВидыСравненияПоказателейОповещения.Больше;
		Объект.ФорматнаяСтрокаЗначения = "[ЧДЦ='2']";
		
		ОбъектЗначение = РеквизитФормыВЗначение("Объект");
	
		Если НЕ ЗначениеЗаполнено(ОбъектЗначение.ПолучитьСсылкуНового()) Тогда
			ОбъектЗначение.УстановитьСсылкуНового(Справочники.ПоказателиИнцидентов.ПолучитьСсылку());
			ЭтотОбъект.Параметры.СсылкаНового = ОбъектЗначение.ПолучитьСсылкуНового();
		КонецЕсли;
	КонецЕсли;
	
	
	//Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
	//	Объект.Функция = Перечисления.ФункцииОповещений.Максимум;
	//	Объект.ИнтервалРасчета = 60;
	//	Объект.ЕдиницаВремениИнтервалаРасчета = Перечисления.ЕдиницыВремени.Секунда;
	//	Объект.ВидСравнения = Перечисления.ВидыСравненияПоказателейОповещения.Больше;
	//	ДанныеОбъекта = РеквизитФормыВЗначение("Объект");
	//	ДанныеОбъекта.Записать();
	//	ЗначениеВРеквизитФормы(ДанныеОбъекта, "Объект");
	//	ЭтоНовый = Истина;
	//КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Показатель) Тогда
		ПоказательСтрокой = Объект.Показатель.Описание;
		ИмяСправочникаПоказателя = Объект.Показатель.Метаданные().Имя;
	КонецЕсли;
	
	СравниватьСПрошлымСтрокой = ?(Объект.СравниватьСПрошлым, "Истина", "Ложь");
	ПорогВПроцентахСтрокой = ?(Объект.ПорогВПроцентах, "Истина", "Ложь");
	
	Если Объект.СравниватьСПрошлым Тогда
		ЭтотОбъект.Элементы.СмещениеБазы.Доступность = Истина;
		
		ЭтотОбъект.Элементы.ВидСравнения1.СписокВыбора.Очистить();
		ЭтотОбъект.Элементы.ВидСравнения1.СписокВыбора.Добавить(Перечисления.ВидыСравненияПоказателейОповещения.Изменился, "изменилось на");
		
		ЭтотОбъект.Элементы.Порог.Заголовок = " на";
		
		ЭтотОбъект.Элементы.ПорогВПроцентах.СписокВыбора.Очистить();
		ЭтотОбъект.Элементы.ПорогВПроцентах.СписокВыбора.Добавить(Истина, "%");
		ЭтотОбъект.Элементы.ПорогВПроцентах.СписокВыбора.Добавить(Ложь, "ед.");
	Иначе
		ЭтотОбъект.Элементы.СмещениеБазы.Доступность = Ложь;
		
		ЭтотОбъект.Элементы.ВидСравнения1.СписокВыбора.Очистить();
		ЭтотОбъект.Элементы.ВидСравнения1.СписокВыбора.Добавить(Перечисления.ВидыСравненияПоказателейОповещения.Больше, "больше чем");
		ЭтотОбъект.Элементы.ВидСравнения1.СписокВыбора.Добавить(Перечисления.ВидыСравненияПоказателейОповещения.Меньше, "меньше чем");
		
		ЭтотОбъект.Элементы.Порог.Заголовок = "чем";
		
		ЭтотОбъект.Элементы.ПорогВПроцентах.СписокВыбора.Очистить();
		ЭтотОбъект.Элементы.ПорогВПроцентах.СписокВыбора.Добавить(Ложь, "ед.");
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура СравниватьСПрошлымПриИзменении(Элемент)
	
	Если Объект.СравниватьСПрошлым Тогда
		ЭтотОбъект.Элементы.СмещениеБазы.Доступность = Истина;
		
		ЭтотОбъект.Элементы.ВидСравнения1.СписокВыбора.Очистить();
		
		ИзменилсяЗначение = ПредопределенноеЗначение("Перечисление.ВидыСравненияПоказателейОповещения.Изменился");
		ЭтотОбъект.Элементы.ВидСравнения1.СписокВыбора.Добавить(ИзменилсяЗначение, "изменилось на");
		Объект.ВидСравнения = ИзменилсяЗначение;
		
		ЭтотОбъект.Элементы.Порог.Заголовок = " на";
		
		ЭтотОбъект.Элементы.ПорогВПроцентах.СписокВыбора.Очистить();
		ЭтотОбъект.Элементы.ПорогВПроцентах.СписокВыбора.Добавить(Истина, "%");
		ЭтотОбъект.Элементы.ПорогВПроцентах.СписокВыбора.Добавить(Ложь, "ед.");
	Иначе
		ЭтотОбъект.Элементы.СмещениеБазы.Доступность = Ложь;
		
		ЭтотОбъект.Элементы.ВидСравнения1.СписокВыбора.Очистить();
		ЭтотОбъект.Элементы.ВидСравнения1.СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВидыСравненияПоказателейОповещения.Больше"), "больше чем");
		ЭтотОбъект.Элементы.ВидСравнения1.СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВидыСравненияПоказателейОповещения.Меньше"), "меньше чем");
		
		ЭтотОбъект.Элементы.Порог.Заголовок = "чем";
		
		ЭтотОбъект.Элементы.ПорогВПроцентах.СписокВыбора.Очистить();
		ЭтотОбъект.Элементы.ПорогВПроцентах.СписокВыбора.Добавить(Ложь, "ед.");
		Объект.ПорогВПроцентах = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОтобразитьБазовоеЗначение();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если ЭтоНовый Или ПоказательИзменен Тогда
		ПриЗакрытииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если Источник.ВладелецФормы <> ЭтотОбъект Тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяСобытия = "ЗакрытьФорму" Тогда
		Оповестить("ЗаписьПоказателяОповещения",,ЭтотОбъект);
		ЭтоНовый = Ложь;
		ПоказательИзменен = Ложь;
		ЭтотОбъект.Закрыть();
	КонецЕсли;
		
	Если ТипЗнч(Параметр) = Тип("Структура") Тогда
		Если Не ЗначениеЗаполнено(Объект.Показатель) Тогда
			Объект.Показатель = Параметр.Ссылка;
			ПоказательИзменен = Истина;
		КонецЕсли;
		ПоказательСтрокой = Параметр.Описание;
	ИначеЕсли ТипЗнч(Параметр) = Тип("Массив") Тогда
		Если Не ЗначениеЗаполнено(Объект.Показатель) Тогда
			Объект.Показатель = Параметр[0].Ссылка;
		КонецЕсли;
		ПоказательСтрокой = Параметр[0].Описание;
		ЭтотОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Объект.ЕдиницаВремениИнтервалаБазы = Объект.ЕдиницаВремениИнтервалаРасчета;
	Объект.ИнтервалБазы = Объект.ИнтервалРасчета;
	
	ПараметрыЗаписи.Вставить("ОписаниеПоказателя", ЭтотОбъект.ПоказательСтрокой);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ЭтоНовый = Ложь;
	ПоказательИзменен = Ложь;
	
	Оповестить("ЗаписьПоказателяОповещения",,ЭтотОбъект);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПоказательСтрокойОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура("Ключ", Объект.Показатель);
	
	Если Не ЗначениеЗаполнено(Объект.Показатель) Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПоказательСтрокойОткрытиеЗавершение", ЭтотОбъект, ПараметрыФормы);
		ОткрытьФорму("Обработка.Мониторинг.Форма.ВыборПоказателя",,ЭтотОбъект,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", Новый Структура("Владелец", Объект.Ссылка));
		ПоказательСтрокойОткрытиеОбщий(ПараметрыФормы, ИмяСправочникаПоказателя);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПоказательСтрокойОткрытиеЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия <> Неопределено Тогда
		ИмяСправочникаПоказателя = РезультатЗакрытия.ИмяСправочника;
		Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
			ДополнительныеПараметры.Вставить("ЗначенияЗаполнения", Новый Структура("Владелец, ЭтоНовый", Объект.Ссылка, Ложь));
		Иначе
			ДополнительныеПараметры.Вставить("ЗначенияЗаполнения", Новый Структура("Владелец, ЭтоНовый", ЭтотОбъект.Параметры.СсылкаНового, Истина));
		КонецЕсли;
		ПоказательСтрокойОткрытиеОбщий(ДополнительныеПараметры, ИмяСправочникаПоказателя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательСтрокойОткрытиеОбщий(ПараметрыФормы, ИмяСправочника)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПоказательСтрокойОткрытиеОбщийЗавершение", ЭтотОбъект);
	ОткрытьФорму(ИмяФормыРедактированияПоказателя(ИмяСправочника), ПараметрыФормы, ЭтотОбъект,,,,ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательСтрокойОткрытиеОбщийЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если  РезультатЗакрытия <> Неопределено Тогда
		Если РезультатЗакрытия = "Закрыть" Тогда
			Оповестить("ЗаписьПоказателяОповещения",,ЭтотОбъект);
			ЭтоНовый = Ложь;
			ПоказательИзменен = Ложь;
			ЭтотОбъект.Закрыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры



///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПриЗакрытииНаСервере()
	
	Если ЭтоНовый Тогда
		УдалениеОбъекта = Новый УдалениеОбъекта(Объект.Ссылка);
		УдалениеОбъекта.Записать();
	ИначеЕсли ПоказательИзменен Тогда
		УдалениеОбъекта = Новый УдалениеОбъекта(Объект.Показатель);
		УдалениеОбъекта.Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ИмяФормыРедактированияПоказателя(Знач ИмяСправочника)
	Возврат "Справочник." + ИмяСправочника + ".ФормаОбъекта";
КонецФункции

&НаКлиенте
Процедура ОтобразитьБазовоеЗначение()
	
	//Если СравниватьСПрошлымСтрокой = "Истина" Тогда
	//	Элементы.СтраницыПараметрыБазовогоЗначения.ТекущаяСтраница = Элементы.СтраницаОтображатьПараметры;
	//	Элементы.СтраницыПорог.ТекущаяСтраница = Элементы.СтраницаПорогОтносительный;
	//Иначе
	//	Элементы.СтраницыПараметрыБазовогоЗначения.ТекущаяСтраница = Элементы.СтраницаСкрытьПараметры;
	//	Элементы.СтраницыПорог.ТекущаяСтраница = Элементы.СтраницаПорогАбсолютный;
	//КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПоказательСтрокойПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Для Каждого ТекПараметр Из ПараметрыЗаписи Цикл
		ТекущийОбъект.ДополнительныеСвойства.Вставить(ТекПараметр.Ключ, ТекПараметр.Значение);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ФорматнаяСтрокаЗначенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ФорматнаяСтрокаЗначенияБуфер = Объект.ФорматнаяСтрокаЗначения;
	ИндексНачала = СтрНайти(Объект.ФорматнаяСтрокаЗначения, "[");
	ИндексОкончания = СтрНайти(Объект.ФорматнаяСтрокаЗначения, "]");
	Если ИндексНачала > 0 И ИндексОкончания > 0 Тогда
		ФорматнаяСтрокаЗначенияБуфер = Сред(ФорматнаяСтрокаЗначенияБуфер, ИндексНачала + 1, ИндексОкончания - ИндексНачала - 1);
	КонецЕсли;
	
	КонструкторФорматнойСтроки = Новый КонструкторФорматнойСтроки(ФорматнаяСтрокаЗначенияБуфер);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОкончаниеВводаФорматнойСтроки", ЭтотОбъект);
	КонструкторФорматнойСтроки.Показать(ОписаниеОповещения);
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеВводаФорматнойСтроки(Текст, ДополнительныеПараметры) Экспорт
	
	ИндексНачала = СтрНайти(Объект.ФорматнаяСтрокаЗначения, "[");
	ИндексОкончания = СтрНайти(Объект.ФорматнаяСтрокаЗначения, "]");
	
	Если ИндексНачала > 0 И ИндексОкончания > 0 Тогда
		ФорматнаяСтрокаЗначенияБуфер = Сред(Объект.ФорматнаяСтрокаЗначения, ИндексНачала + 1, ИндексОкончания - ИндексНачала - 1);
		Объект.ФорматнаяСтрокаЗначения = СтрЗаменить(Объект.ФорматнаяСтрокаЗначения, "[" + ФорматнаяСтрокаЗначенияБуфер + "]", "[" + Текст + "]");
	Иначе
		Объект.ФорматнаяСтрокаЗначения = "[" + Текст + "]";
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПоказательОбъект = Объект.Показатель.ПолучитьОбъект();
	ПоказательОбъект.Описание = ЭтотОбъект.ПоказательСтрокой;
	ПоказательОбъект.Записать();
	
КонецПроцедуры

