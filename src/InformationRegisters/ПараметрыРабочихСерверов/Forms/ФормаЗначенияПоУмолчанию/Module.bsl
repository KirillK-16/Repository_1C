
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьОтветственных();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОтветственных()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ВидКонтрольнойПроцедуры,
	|	РольПользователя
	|ИЗ
	|	РегистрСведений.ОтветственныеЗаНастройкуПроцедур
	|ГДЕ
	|	ОбъектКонтроля = &ВидОбъектаКонтроля
	|	И ВидКонтрольнойПроцедуры В (&ВидыКонтрольныхПроцедур)
	|";
	
	АнализВызововКластера1С = Справочники.ВидыКонтрольныхПроцедур.НайтиПоНаименованию("Анализ вызовов кластера 1С");
	КонтрольУстойчивостиСистемы = Справочники.ВидыКонтрольныхПроцедур.НайтиПоНаименованию("Контроль устойчивости системы");
	МониторингСистемныхОшибок = Справочники.ВидыКонтрольныхПроцедур.НайтиПоНаименованию("Мониторинг системных ошибок");
		
	ВидыКонтрольныхПроцедур = Новый Массив;
	ВидыКонтрольныхПроцедур.Добавить(АнализВызововКластера1С);
	ВидыКонтрольныхПроцедур.Добавить(КонтрольУстойчивостиСистемы);
	ВидыКонтрольныхПроцедур.Добавить(МониторингСистемныхОшибок);
	
	Запрос.УстановитьПараметр("ВидОбъектаКонтроля", Справочники.ВидыОбъектовКонтроля.РабочийСервер);
	Запрос.УстановитьПараметр("ВидыКонтрольныхПроцедур", ВидыКонтрольныхПроцедур);
	
	КонтрольныеПроцедуры = Новый Соответствие;
	КонтрольныеПроцедуры.Вставить(АнализВызововКластера1С, Неопределено);
	КонтрольныеПроцедуры.Вставить(КонтрольУстойчивостиСистемы, Неопределено);
	КонтрольныеПроцедуры.Вставить(МониторингСистемныхОшибок, Неопределено);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		КонтрольныеПроцедуры[Выборка.ВидКонтрольнойПроцедуры] = Выборка.РольПользователя;
	КонецЦикла;
	
	Для Каждого ТекКонтрольнаяПроцедура Из КонтрольныеПроцедуры Цикл
		НовСтрока = ЭтотОбъект.ОтветственныеЗаНастройкуКонтрольныхПроцедур.Добавить();
		НовСтрока.ВидКонтрольнойПроцедуры = ТекКонтрольнаяПроцедура.Ключ;
		НовСтрока.РольПользователя = ТекКонтрольнаяПроцедура.Значение;
	КонецЦикла;
			
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Для Каждого ТекСтрока Из ЭтотОбъект.ОтветственныеЗаНастройкуКонтрольныхПроцедур Цикл
		МенеджерЗаписи = РегистрыСведений.ОтветственныеЗаНастройкуПроцедур.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ОбъектКонтроля = Справочники.ВидыОбъектовКонтроля.РабочийСервер;
		МенеджерЗаписи.ВидКонтрольнойПроцедуры = ТекСтрока.ВидКонтрольнойПроцедуры;
		МенеджерЗаписи.РольПользователя = ТекСтрока.РольПользователя;
		МенеджерЗаписи.Записать(Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	ПроверяемыеРеквизиты.Очистить();
КонецПроцедуры
