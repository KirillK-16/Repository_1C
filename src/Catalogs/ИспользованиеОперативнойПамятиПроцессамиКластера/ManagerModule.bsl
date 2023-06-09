#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Функция ПолучитьМассивСтруктурыПоказателей(ТипПоказателя, ИдентификаторНастройки, МассивСтруктурПоказателей, ТолькоВыбранные) Экспорт
	
	МассивСтруктурыПоказателей = Новый Массив;
	
	ТаблицаПоказателей = Новый ТаблицаЗначений;
	ТаблицаПоказателей.Колонки.Добавить("ПоказательМониторинга", Новый ОписаниеТипов("СправочникСсылка.ПоказателиМониторинга"));
	ТаблицаПоказателей.Колонки.Добавить("ГруппаОбъектовКонтроля", Новый ОписаниеТипов("Булево"));
	
	Для Каждого СтруктураПоказатель Из МассивСтруктурПоказателей Цикл
		
		Если ЗначениеЗаполнено(СтруктураПоказатель.Показатель) И СтруктураПоказатель.ТипПоказателя = "ИспользованиеОперативнойПамятиПроцессамиКластера" Тогда
			
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
	СтруктураДанныхГруппы.Вставить("Код", "Группы по кластерам");
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
	|	МониторингПроцессов.Кластер.Наименование КАК КластерНаименование,
	|	МониторингПроцессов.Сервер КАК СерверНаименование,
	|	МониторингПроцессов.Кластер КАК Кластер,
	|	МониторингПроцессов.Сервер КАК Сервер,
	|	ЕСТЬNULL(ТаблицаПоказателей.ПоказательМониторинга, Неопределено) КАК ПоказательМониторинга
	|ИЗ
	|	РегистрСведений.МониторингПроцессов КАК МониторингПроцессов
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ИспользованиеОперативнойПамятиПроцессамиКластера КАК ИспользованиеОперативнойПамятиПроцессамиКластера
	|
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаПоказателей КАК ТаблицаПоказателейОтбор
	|		ПО ТаблицаПоказателейОтбор.ПоказательМониторинга.Показатель = ИспользованиеОперативнойПамятиПроцессамиКластера.Ссылка
	|		И НЕ ТаблицаПоказателейОтбор.ГруппаОбъектовКонтроля
	|
	|	ПО ИспользованиеОперативнойПамятиПроцессамиКластера.Кластер = МониторингПроцессов.Кластер
	|	И ИспользованиеОперативнойПамятиПроцессамиКластера.Сервер = МониторингПроцессов.Сервер
	|	И НЕ ИспользованиеОперативнойПамятиПроцессамиКластера.ВсеКластеры
	|	И НЕ ИспользованиеОперативнойПамятиПроцессамиКластера.ВсеСерверы
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаПоказателей КАК ТаблицаПоказателей
	|	ПО ТаблицаПоказателей.ПоказательМониторинга.Показатель = ИспользованиеОперативнойПамятиПроцессамиКластера.Ссылка
	|
	|ГДЕ
	|	МониторингПроцессов.Кластер <> ЗНАЧЕНИЕ(Справочник.ОбъектыКонтроля.ПустаяСсылка)
	|	И МониторингПроцессов.Сервер <> """"
	|
	|УПОРЯДОЧИТЬ ПО
	|	КластерНаименование,
	|	СерверНаименование
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
		
		ВыборкаСервер = ВыборкаКластер.Выбрать();
		Пока ВыборкаСервер.Следующий() Цикл
		
			Если ТолькоВыбранные И НЕ ЗначениеЗаполнено(ВыборкаСервер.ПоказательМониторинга) Тогда
				Продолжить;
			КонецЕсли;
			
			СтруктураДанныхСервер = Новый Структура();
			
			Если ЗначениеЗаполнено(ВыборкаСервер.ПоказательМониторинга) Тогда
				СтруктураДанныхСервер.Вставить("ПоказательМониторинга", Строка(ВыборкаСервер.ПоказательМониторинга.УникальныйИдентификатор()));
			Иначе
				СтруктураДанныхСервер.Вставить("ПоказательМониторинга", "");
			КонецЕсли;
			
			СтруктураДанныхСервер.Вставить("Код", ВыборкаСервер.СерверНаименование);
			СтруктураДанныхСервер.Вставить("ОбъектКонтроля", Строка(ВыборкаСервер.Кластер.УникальныйИдентификатор()) + "/" + ВыборкаСервер.Сервер);
			СтруктураДанныхСервер.Вставить("МассивСтрок", Новый Массив());
			
			СтруктураДанныхКластер.МассивСтрок.Добавить(СтруктураДанныхСервер);
			
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
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	""Использование памяти/"" + МониторингПроцессов.Кластер.Наименование + ""/"" + МониторингПроцессов.Сервер КАК Представление,
	|	МониторингПроцессов.Кластер КАК Кластер,
	|	МониторингПроцессов.Сервер КАК Сервер
	|ИЗ
	|	РегистрСведений.МониторингПроцессов КАК МониторингПроцессов
	|ГДЕ
	|	(МониторингПроцессов.Кластер.Наименование + ""/"" + МониторингПроцессов.Сервер) ПОДОБНО &СтрокаПоиска
	|	И МониторингПроцессов.Кластер <> ЗНАЧЕНИЕ(Справочник.ОбъектыКонтроля.ПустаяСсылка)
	|	И МониторингПроцессов.Сервер <> """"
	|
	|УПОРЯДОЧИТЬ ПО
	|	Представление
	|";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтруктураРезультата = Новый Структура();
		СтруктураРезультата.Вставить("Представление", Выборка.Представление);
		СтруктураРезультата.Вставить("ОбъектКонтроля", Строка(Выборка.Кластер.УникальныйИдентификатор()) + "/" + Выборка.Сервер);
		СтруктураРезультата.Вставить("ТипПоказателя", "ИспользованиеОперативнойПамятиПроцессамиКластера");
		
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
	|	Справочник.ИспользованиеОперативнойПамятиПроцессамиКластера
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