#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Функция ПолучитьМассивСтруктурыПоказателей(ТипПоказателя, ИдентификаторНастройки, МассивСтруктурПоказателей, ТолькоВыбранные) Экспорт
	
	МассивСтруктурыПоказателей = Новый Массив;
	
	ТаблицаПоказателей = Новый ТаблицаЗначений;
	ТаблицаПоказателей.Колонки.Добавить("ПоказательМониторинга", Новый ОписаниеТипов("СправочникСсылка.ПоказателиМониторинга"));
	ТаблицаПоказателей.Колонки.Добавить("ГруппаОбъектовКонтроля", Новый ОписаниеТипов("Булево"));
	
	Для Каждого СтруктураПоказатель Из МассивСтруктурПоказателей Цикл
		
		Если ЗначениеЗаполнено(СтруктураПоказатель.Показатель) И СтруктураПоказатель.ТипПоказателя = "ЧислоСеансовПользователей" Тогда
			
			НоваяСтрока							= ТаблицаПоказателей.Добавить();
			НоваяСтрока.ПоказательМониторинга	= СтруктураПоказатель.Показатель;
			НоваяСтрока.ГруппаОбъектовКонтроля	= СтруктураПоказатель.ГруппаОбъектовКонтроля;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ИдентификаторНастройки", ИдентификаторНастройки);
	Запрос.УстановитьПараметр("ТаблицаПоказателей", ТаблицаПоказателей);
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ТаблицаПоказателей.ПоказательМониторинга КАК ПоказательМониторинга,
	|	ТаблицаПоказателей.ГруппаОбъектовКонтроля КАК ГруппаОбъектовКонтроля
	|ПОМЕСТИТЬ
	|	ТаблицаПоказателей
	|ИЗ
	|	&ТаблицаПоказателей КАК ТаблицаПоказателей
	|
	|;
	|
	|ВЫБРАТЬ
	|	ТаблицаПоказателей.ПоказательМониторинга.Наименование Как Код,
	|	ТаблицаПоказателей.ПоказательМониторинга КАК ПоказательМониторинга
	|ИЗ
	|	ТаблицаПоказателей КАК ТаблицаПоказателей
	|ГДЕ
	|	ТаблицаПоказателей.ГруппаОбъектовКонтроля
	|
	|УПОРЯДОЧИТЬ ПО
	|	Код
	|";
	
	СтруктураДанныхГруппы = Новый Структура();
	СтруктураДанныхГруппы.Вставить("ПоказательМониторинга", "");
	СтруктураДанныхГруппы.Вставить("ОбъектКонтроля", "ГруппаОбъектовКонтроляРодитель");
	СтруктураДанныхГруппы.Вставить("Код", "Группы сеансов");
	СтруктураДанныхГруппы.Вставить("МассивСтрок", Новый Массив());
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтруктураДанных = Новый Структура();
		СтруктураДанных.Вставить("ПоказательМониторинга", Строка(Выборка.ПоказательМониторинга.УникальныйИдентификатор()));
		СтруктураДанных.Вставить("ОбъектКонтроля", "ГруппаОбъектовКонтроля");
		СтруктураДанных.Вставить("Код", Выборка.Код);
		СтруктураДанных.Вставить("МассивСтрок", Новый Массив());
		
		СтруктураДанныхГруппы.МассивСтрок.Добавить(СтруктураДанных);
		
	КонецЦикла;
	
	МассивСтруктурыПоказателей.Добавить(СтруктураДанныхГруппы);
	
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Базы.ОбъектКонтроля.Наименование КАК БазаНаименование,
	|	Базы.Кластер.Наименование КАК КластерНаименование,
	|	Базы.Кластер КАК Кластер,
	|	Базы.ОбъектКонтроля КАК ОбъектКонтроля,
	|	ЕСТЬNULL(ТаблицаПоказателей.ПоказательМониторинга, Неопределено) КАК ПоказательМониторинга
	|ИЗ
	|	РегистрСведений.ПараметрыИнформационныхБаз КАК Базы
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЧислоСеансовПользователей.ИнформационныеБазы КАК ЧислоСеансовПользователейИнформационныеБазы
	|
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаПоказателей КАК ТаблицаПоказателейОтбор
	|		ПО ТаблицаПоказателейОтбор.ПоказательМониторинга.Показатель = ЧислоСеансовПользователейИнформационныеБазы.Ссылка
	|		И НЕ ТаблицаПоказателейОтбор.ГруппаОбъектовКонтроля
	|
	|	ПО ЧислоСеансовПользователейИнформационныеБазы.ИнформационнаяБазаСсылка = Базы.ОбъектКонтроля
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаПоказателей КАК ТаблицаПоказателей
	|	ПО ТаблицаПоказателей.ПоказательМониторинга.Показатель = ЧислоСеансовПользователейИнформационныеБазы.Ссылка
	|
	|ГДЕ
	|	Базы.ОбъектКонтроля <> ЗНАЧЕНИЕ(Справочник.ОбъектыКонтроля.ПустаяСсылка)
	|	И Базы.Кластер <> ЗНАЧЕНИЕ(Справочник.ОбъектыКонтроля.ПустаяСсылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	КластерНаименование,
	|	БазаНаименование
	|
	|ИТОГИ 
	|	МАКСИМУМ(КластерНаименование) КАК КластерНаименование,
	|	МАКСИМУМ(ПоказательМониторинга) КАК ПоказательМониторинга
	|ПО
	|	Кластер
	|";
	
	ВыборкаКластер = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Кластер");
	Пока ВыборкаКластер.Следующий() Цикл
		
		Если ТолькоВыбранные И НЕ ЗначениеЗаполнено(ВыборкаКластер.ПоказательМониторинга) Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураДанныхКластер = Новый Структура();
		СтруктураДанныхКластер.Вставить("ПоказательМониторинга", "");
		СтруктураДанныхКластер.Вставить("Код", ВыборкаКластер.КластерНаименование);
		СтруктураДанныхКластер.Вставить("ОбъектКонтроля", Строка(ВыборкаКластер.Кластер.УникальныйИдентификатор()));
		СтруктураДанныхКластер.Вставить("МассивСтрок", Новый Массив());
		
		ВыборкаБаза = ВыборкаКластер.Выбрать();
		Пока ВыборкаБаза.Следующий() Цикл
		
			Если ТолькоВыбранные И НЕ ЗначениеЗаполнено(ВыборкаБаза.ПоказательМониторинга) Тогда
				Продолжить;
			КонецЕсли;
			
			СтруктураДанныхБаза = Новый Структура();
			
			Если ЗначениеЗаполнено(ВыборкаБаза.ПоказательМониторинга) Тогда
				СтруктураДанныхБаза.Вставить("ПоказательМониторинга", Строка(ВыборкаБаза.ПоказательМониторинга.УникальныйИдентификатор()));
			Иначе
				СтруктураДанныхБаза.Вставить("ПоказательМониторинга", "");
			КонецЕсли;
			
			СтруктураДанныхБаза.Вставить("Код", ВыборкаБаза.БазаНаименование);
			СтруктураДанныхБаза.Вставить("ОбъектКонтроля", Строка(ВыборкаБаза.Кластер.УникальныйИдентификатор()) + "/" + Строка(ВыборкаБаза.ОбъектКонтроля.УникальныйИдентификатор()));
			СтруктураДанныхБаза.Вставить("МассивСтрок", Новый Массив());
			
			СтруктураДанныхКластер.МассивСтрок.Добавить(СтруктураДанныхБаза);
			
		КонецЦикла;
		
		МассивСтруктурыПоказателей.Добавить(СтруктураДанныхКластер);
		
	КонецЦикла;
	
	Возврат МассивСтруктурыПоказателей;
	
КонецФункции

Функция ПоискПоказателей(Знач СтрокаПоиска) Экспорт
	
	СтрокаПоиска = СтрЗаменить(СтрокаПоиска, """", "");
	
	МассивРезультатов = Новый Массив;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("СтрокаПоиска", "%" + СтрокаПоиска + "%");
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	""Сеансы/"" + ПараметрыИнформационныхБаз.Кластер.Наименование + ""/"" + ПараметрыИнформационныхБаз.ОбъектКонтроля.Наименование КАК Представление,
	|	ПараметрыИнформационныхБаз.ОбъектКонтроля.Наименование КАК БазаПредставление,
	|	ПараметрыИнформационныхБаз.Кластер КАК Кластер,
	|	ПараметрыИнформационныхБаз.ОбъектКонтроля КАК ОбъектКонтроля
	|ИЗ
	|	РегистрСведений.ПараметрыИнформационныхБаз КАК ПараметрыИнформационныхБаз
	|ГДЕ
	|	(ПараметрыИнформационныхБаз.Кластер.Наименование + ""/"" + ПараметрыИнформационныхБаз.ОбъектКонтроля.Наименование) ПОДОБНО &СтрокаПоиска
	|	И ПараметрыИнформационныхБаз.ОбъектКонтроля <> ЗНАЧЕНИЕ(Справочник.ОбъектыКонтроля.ПустаяСсылка)
	|	И ПараметрыИнформационныхБаз.Кластер <> ЗНАЧЕНИЕ(Справочник.ОбъектыКонтроля.ПустаяСсылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Представление
	|";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтруктураРезультата = Новый Структура();
		СтруктураРезультата.Вставить("Представление", Выборка.Представление);
		СтруктураРезультата.Вставить("ОбъектКонтроля", Строка(Выборка.Кластер.УникальныйИдентификатор()) + "/" + Строка(Выборка.ОбъектКонтроля.УникальныйИдентификатор()));
		СтруктураРезультата.Вставить("ТипПоказателя", "ЧислоСеансовПользователей");
		
		МассивРезультатов.Добавить(СтруктураРезультата);
		
	КонецЦикла;
	
	Возврат МассивРезультатов;
	
КонецФункции

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	Запрос = Новый Запрос;
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Описание
	|ИЗ
	|	Справочник.ЧислоСеансовПользователей
	|ГДЕ
	|	Ссылка = &Ссылка
	|";
	Запрос.УстановитьПараметр("Ссылка", Данные.Ссылка);
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		Представление = Выборка.Описание;
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

#КонецЕсли