#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
// Расчитывает итоги по статистике информационных баз
//
//	Параметры:
//		ДатаНачала		- Дата. Начало периода расчета итогов
//		ДатаОкончания	- Дата. Окончание периода расчета итогов
//
Процедура ПересчетИтогов(Знач ДатаНачала = Неопределено, Знач ДатаОкончания = Неопределено) Экспорт
	
	ДатаНачала		= ?(ЗначениеЗаполнено(ДатаНачала), НачалоДня(ДатаНачала), '00010101');
	ДатаОкончания	= ?(ЗначениеЗаполнено(ДатаОкончания), КонецДня(ДатаОкончания), КонецДня(ТекущаяДата()));
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	
	// чистка старых записей за период
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СтатистикаПоИнформационнымБазамИтоги.Период КАК Период
	|ИЗ
	|	РегистрСведений.СтатистикаПоИнформационнымБазамИтоги КАК СтатистикаПоИнформационнымБазамИтоги
	|ГДЕ
	|	СтатистикаПоИнформационнымБазамИтоги.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
	|";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НаборЗаписей = РегистрыСведений.СтатистикаПоИнформационнымБазамИтоги.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Период.Установить(Выборка.Период);
		НаборЗаписей.Записать(Истина);
		
	КонецЦикла;
	
	// курсор по месяцам
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПериодМесяц КАК ПериодМесяц
	|ИЗ
	|	(
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		НачалоПериода(СтатистикаПоИнформационнымБазам.Дата, Месяц) КАК ПериодМесяц
	|	ИЗ
	|		РегистрСведений.СтатистикаПоИнформационнымБазам КАК СтатистикаПоИнформационнымБазам
	|	ГДЕ
	|		СтатистикаПоИнформационнымБазам.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|
	|	ОБЪЕДИНИТЬ
	|
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		НачалоПериода(ЧислоВызововСервера.Период, Месяц) КАК ПериодМесяц
	|	ИЗ
	|		РегистрСведений.ЧислоВызововСервера КАК ЧислоВызововСервера
	|
	|	ГДЕ
	|		ЧислоВызововСервера.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
	|
	|	ОБЪЕДИНИТЬ
	|
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		НачалоПериода(ЧислоСеансов.Период, Месяц) КАК ПериодМесяц
	|	ИЗ
	|		РегистрСведений.ЧислоСеансов КАК ЧислоСеансов
	|
	|	ГДЕ
	|		ЧислоСеансов.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
	|
	|	) КАК ВнутреннийЗапрос
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПериодМесяц
	|";
	
	ВыборкаМесяц = Запрос.Выполнить().Выбрать();
	Пока ВыборкаМесяц.Следующий() Цикл
		
		// расчет итогов за месяц
		Запрос.УстановитьПараметр("ДатаНачала", Макс(ДатаНачала, НачалоМесяца(ВыборкаМесяц.ПериодМесяц)));
		Запрос.УстановитьПараметр("ДатаОкончания", Мин(ДатаОкончания, КонецМесяца(ВыборкаМесяц.ПериодМесяц)));
		
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	ВложенныйЗапрос.ИнформационнаяБаза КАК ИнформационнаяБаза,
		|	НачалоПериода(ВложенныйЗапрос.Дата, День) КАК Период,
		|	НачалоПериода(ВложенныйЗапрос.Дата, Час) КАК ПериодЧас,
		|	СУММА(ВложенныйЗапрос.ИзмененоОбъектов) КАК ИзмененоОбъектовСумма,
		|	СУММА(ВложенныйЗапрос.СозданоОбъектов) КАК СозданоОбъектовСумма,
		|	СУММА(ВложенныйЗапрос.СформированоОтчетов) КАК СформированоОтчетовСумма,
		|	СУММА(ВложенныйЗапрос.ПроведеноДокументов) КАК ПроведеноДокументовСумма,
		|	СУММА(ВложенныйЗапрос.ЧислоВызововСервера) КАК ЧислоВызововСервераСумма,
		|	СУММА(ВложенныйЗапрос.ЧислоСеансов) КАК ЧислоСеансовСумма,
		|	СУММА(ВЫБОР КОГДА ВложенныйЗапрос.ИзмененоОбъектов = 0 ТОГДА 0 ИНАЧЕ 1 КОНЕЦ) КАК ИзмененоОбъектовКоличество,
		|	СУММА(ВЫБОР КОГДА ВложенныйЗапрос.СозданоОбъектов = 0 ТОГДА 0 ИНАЧЕ 1 КОНЕЦ) КАК СозданоОбъектовКоличество,
		|	СУММА(ВЫБОР КОГДА ВложенныйЗапрос.СформированоОтчетов = 0 ТОГДА 0 ИНАЧЕ 1 КОНЕЦ) КАК СформированоОтчетовКоличество,
		|	СУММА(ВЫБОР КОГДА ВложенныйЗапрос.ПроведеноДокументов = 0 ТОГДА 0 ИНАЧЕ 1 КОНЕЦ) КАК ПроведеноДокументовКоличество,
		|	СУММА(ВЫБОР КОГДА ВложенныйЗапрос.ЧислоВызововСервера = 0 ТОГДА 0 ИНАЧЕ 1 КОНЕЦ) КАК ЧислоВызововСервераКоличество,
		|	СУММА(ВЫБОР КОГДА ВложенныйЗапрос.ЧислоСеансов = 0 ТОГДА 0 ИНАЧЕ 1 КОНЕЦ) КАК ЧислоСеансовКоличество,
		|	МИНИМУМ(ВложенныйЗапрос.ИзмененоОбъектов) КАК ИзмененоОбъектовМинимум,
		|	МИНИМУМ(ВложенныйЗапрос.СозданоОбъектов) КАК СозданоОбъектовМинимум,
		|	МИНИМУМ(ВложенныйЗапрос.СформированоОтчетов) КАК СформированоОтчетовМинимум,
		|	МИНИМУМ(ВложенныйЗапрос.ПроведеноДокументов) КАК ПроведеноДокументовМинимум,
		|	МИНИМУМ(ВложенныйЗапрос.ЧислоВызововСервера) КАК ЧислоВызововСервераМинимум,
		|	МИНИМУМ(ВложенныйЗапрос.ЧислоСеансов) КАК ЧислоСеансовМинимум,
		|	МАКСИМУМ(ВложенныйЗапрос.ИзмененоОбъектов) КАК ИзмененоОбъектовМаксимум,
		|	МАКСИМУМ(ВложенныйЗапрос.СозданоОбъектов) КАК СозданоОбъектовМаксимум,
		|	МАКСИМУМ(ВложенныйЗапрос.СформированоОтчетов) КАК СформированоОтчетовМаксимум,
		|	МАКСИМУМ(ВложенныйЗапрос.ПроведеноДокументов) КАК ПроведеноДокументовМаксимум,
		|	МАКСИМУМ(ВложенныйЗапрос.ЧислоВызововСервера) КАК ЧислоВызововСервераМаксимум,
		|	МАКСИМУМ(ВложенныйЗапрос.ЧислоСеансов) КАК ЧислоСеансовМаксимум
		|
		|ИЗ
		|	(
		|	ВЫБРАТЬ
		|		СтатистикаПоИнформационнымБазам.ИнформационнаяБаза КАК ИнформационнаяБаза,
		|		СтатистикаПоИнформационнымБазам.Дата КАК Дата,
		|		СтатистикаПоИнформационнымБазам.ИзмененоОбъектов КАК ИзмененоОбъектов,
		|		СтатистикаПоИнформационнымБазам.СозданоОбъектов КАК СозданоОбъектов,
		|		СтатистикаПоИнформационнымБазам.СформированоОтчетов КАК СформированоОтчетов,
		|		СтатистикаПоИнформационнымБазам.ПроведеноДокументов КАК ПроведеноДокументов,
		|		0 КАК ЧислоВызововСервера,
		|		0 КАК ЧислоСеансов
		|
		|	ИЗ
		|		РегистрСведений.СтатистикаПоИнформационнымБазам КАК СтатистикаПоИнформационнымБазам
		|
		|	ГДЕ
		|		СтатистикаПоИнформационнымБазам.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|
		|	ОБЪЕДИНИТЬ ВСЕ
		|
		|	ВЫБРАТЬ
		|		ЧислоВызововСервера.ИнформационнаяБаза КАК ИнформационнаяБаза,
		|		ЧислоВызововСервера.Период КАК Дата,
		|		0 КАК ИзмененоОбъектов,
		|		0 КАК СозданоОбъектов,
		|		0 КАК СформированоОтчетов,
		|		0 КАК ПроведеноДокументов,
		|		ЧислоВызововСервера.Количество КАК ЧислоВызововСервера,
		|		0 КАК ЧислоСеансов
		|
		|	ИЗ
		|		РегистрСведений.ЧислоВызововСервера КАК ЧислоВызововСервера
		|
		|	ГДЕ
		|		ЧислоВызововСервера.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
		|
		|	ОБЪЕДИНИТЬ ВСЕ
		|
		|	ВЫБРАТЬ
		|		ЧислоСеансов.ИнформационнаяБаза КАК ИнформационнаяБаза,
		|		ЧислоСеансов.Период КАК Дата,
		|		0 КАК ИзмененоОбъектов,
		|		0 КАК СозданоОбъектов,
		|		0 КАК СформированоОтчетов,
		|		0 КАК ПроведеноДокументов,
		|		0 КАК ЧислоВызововСервера,
		|		ЧислоСеансов.Количество КАК ЧислоСеансов
		|
		|	ИЗ
		|		РегистрСведений.ЧислоСеансов КАК ЧислоСеансов
		|
		|	ГДЕ
		|		ЧислоСеансов.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
		|
		|	) КАК ВложенныйЗапрос
		|
		|СГРУППИРОВАТЬ ПО
		|	ВложенныйЗапрос.ИнформационнаяБаза,
		|	НачалоПериода(ВложенныйЗапрос.Дата, День),
		|	НачалоПериода(ВложенныйЗапрос.Дата, Час)
		|
		|ИТОГИ ПО
		|	ИнформационнаяБаза
		|";
		
		ВыборкаИнформационнаяБаза = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ИнформационнаяБаза");
		Пока ВыборкаИнформационнаяБаза.Следующий() Цикл
			
			НаборЗаписей = РегистрыСведений.СтатистикаПоИнформационнымБазамИтоги.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.ИнформационнаяБаза.Установить(ВыборкаИнформационнаяБаза.ИнформационнаяБаза);
			
			Выборка = ВыборкаИнформационнаяБаза.Выбрать();
			Пока Выборка.Следующий() Цикл
				
				Запись = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(Запись, Выборка);
				
			КонецЦикла;
			
			НаборЗаписей.Записать(Ложь);
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли