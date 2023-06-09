#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
    
#Область ПрограммныйИнтерфейс

Функция СчетчикиПоказателя(Ссылка) Экспорт
    
    Запрос = Новый Запрос;
    
    Запрос.Текст = "
    |ВЫБРАТЬ
    |   Счетчик
    |ИЗ
    |   Справочник.ПоказателиСчетчиков.Счетчики
    |ГДЕ
    |   Ссылка = &Ссылка
    |";
    
    Запрос.УстановитьПараметр("Ссылка",Ссылка);
    
    Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Счетчик");
    
КонецФункции

// Создает новый показатель счетчика с одним счетчиком
//  Параметры:
//    Владелец  - СправочникСсылка.ПоказателиМониторинга,
//                СправочникСсылка.ПоказателиОповещений,
//                СправочникСсылка.ПоказателиИнцидентов - владелец нового элемента
//    Счетчик   - СправочникСсылка.ГруппыСчетчиков      - счетчик для создания показателя
//    Параметры - Структура                             - структура создания показателя с ключами:
//                                                      Аналитика     - Перечисление.АналитикаСчетчиков
//                                                      Периодичность - Перечисление.ПереодичностьСчетчиков
//                                                      РегулярноеВыражениеПоиска - Строка
//                                                      РегулярноеВыражениеЗамены - Строка
//
Функция СоздатьЭлементПоСчетчику(Владелец, Счетчик, Параметры) Экспорт
    
    Элемент = Справочники.ПоказателиСчетчиков.СоздатьЭлемент();
    Элемент.Владелец = Владелец;
    Элемент.Пользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
    Элемент.Описание = Счетчик.ПолныйКодДляПоиска;
    
    Если ЗначениеЗаполнено(Параметры.РегулярноеВыражениеПоиска) И ЗначениеЗаполнено(Параметры.РегулярноеВыражениеЗамены) Тогда
        Элемент.Описание = РегулярныеВыраженияКлиентСервер.ЗаменитьПоШаблонуПоиска(Элемент.Описание, Параметры.РегулярноеВыражениеПоиска, Параметры.РегулярноеВыражениеЗамены);
    КонецЕсли;
        
    Элемент.Аналитика = Строка(Параметры.Аналитика);
    Элемент.ГУИД = Новый УникальныйИдентификатор;
    Элемент.Периодичность = Строка(Параметры.Периодичность);
    
    НовыйСчетчик = Элемент.Счетчики.Добавить();
    НовыйСчетчик.Счетчик = Счетчик;
    
    Элемент.Записать();
    
    Возврат Элемент.Ссылка;
    
КонецФункции

Функция СоздатьЭлементXML(Параметры) Экспорт
    
    НовыйПоказательСчетчиков = Справочники.ПоказателиСчетчиков.СоздатьЭлемент();
    НовыйПоказательСчетчиков.УстановитьСсылкуНового(Справочники.ПоказателиСчетчиков.ПолучитьСсылку());
    НовыйПоказательСчетчиков.Пользователь = СловарьСервер.ТекущийПользователь();
    НовыйПоказательСчетчиков.ГУИД = Новый УникальныйИдентификатор();
    НовыйПоказательСчетчиков.Владелец = Параметры.Владелец;
    НовыйПоказательСчетчиков.Периодичность = Параметры.Периодичность;
    НовыйПоказательСчетчиков.Аналитика = Параметры.Аналитика;
    
    Для Каждого Данные Из Параметры.Счетчики Цикл
        
        НоваяСтрокаПоказательСчетчиков = НовыйПоказательСчетчиков.Счетчики.Добавить();
        НоваяСтрокаПоказательСчетчиков.Счетчик = Данные.Счетчик;
        НоваяСтрокаПоказательСчетчиков.Группа = Данные.Группа;
        
    КонецЦикла;
    
    Если Параметры.Свойство("РегулярноеВыражениеПоиска") И Параметры.Свойство("РегулярноеВыражениеЗамены") Тогда
        Если ЗначениеЗаполнено(Параметры.РегулярноеВыражениеПоиска) И ЗначениеЗаполнено(Параметры.РегулярноеВыражениеЗамены) Тогда
            ОписаниеСчетчика = РегулярныеВыраженияКлиентСервер.ЗаменитьПоШаблонуПоиска(Параметры.Описание, Параметры.РегулярноеВыражениеПоиска, Параметры.РегулярноеВыражениеЗамены);
        Иначе
            ОписаниеСчетчика = Параметры.Описание;
        КонецЕсли;
    Иначе
        ОписаниеСчетчика = Параметры.Описание;
    КонецЕсли;
    НовыйПоказательСчетчиков.Описание = ОписаниеСчетчика;
    
    НовыйПоказательСчетчиков.УстановитьСсылкуНового(Справочники.ПоказателиСчетчиков.ПолучитьСсылку());
    Поток = Новый ЗаписьXML();
    Поток.УстановитьСтроку();
    СериализаторXDTO.ЗаписатьXML(Поток, НовыйПоказательСчетчиков);
    
    Возврат Поток.Закрыть();
    
КонецФункции

#КонецОбласти
    
#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСчетчикиВМассив(ПоказательСсылка) Экспорт
	Счетчики = Новый Массив;
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ПоказателиСчетчиковСчетчики.Счетчик КАК Счетчик
	|ИЗ
	|	Справочник.ПоказателиСчетчиков.Счетчики КАК ПоказателиСчетчиковСчетчики
	|ГДЕ
	|	ПоказателиСчетчиковСчетчики.Ссылка = &ПоказательСсылка
	|";
	Запрос.УстановитьПараметр("ПоказательСсылка", ПоказательСсылка);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		Счетчики.Добавить(Выборка.Счетчик);
	КонецЦикла;
	
	Возврат Счетчики;
КонецФункции

Функция ЗаполнитьМассивСчетчиковРекурсивно(МассивДанных, ВыборкаКорень, ТолькоВыбранные)
	
	Пока ВыборкаКорень.Следующий() Цикл
		
		СтруктураДанных = Новый Структура();
		
		Если ВыборкаКорень.ПоказательМониторинга = Неопределено Тогда
			СтруктураДанных.Вставить("ПоказательМониторинга", "");
		Иначе
			СтруктураДанных.Вставить("ПоказательМониторинга", Строка(ВыборкаКорень.ПоказательМониторинга.УникальныйИдентификатор()));
		КонецЕсли;
		
		СтруктураДанных.Вставить("Код", ВыборкаКорень.Код);
		СтруктураДанных.Вставить("ОбъектКонтроля", ВыборкаКорень.ГруппаСчетчиков);
		СтруктураДанных.Вставить("МассивСтрок", Новый Массив());
		
		МассивДанных.Добавить(СтруктураДанных);
		
		Выборка = ВыборкаКорень.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
		ЗаполнитьМассивСчетчиковРекурсивно(СтруктураДанных.МассивСтрок, Выборка, ТолькоВыбранные);
		
		Если ТолькоВыбранные Тогда
			
			Если ВыборкаКорень.ПоказательМониторинга = Неопределено
				И СтруктураДанных.МассивСтрок.Количество() = 0 Тогда
				
				МассивДанных.Удалить(МассивДанных.ВГраница());
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецФункции

Функция ПолучитьМассивСтруктурыПоказателей(ТипПоказателя, ИдентификаторНастройки, МассивСтруктурПоказателей, ТолькоВыбранные) Экспорт
	
	МассивСтруктурыПоказателей = Новый Массив;
	
	ТаблицаПоказателей = Новый ТаблицаЗначений;
	ТаблицаПоказателей.Колонки.Добавить("ПоказательМониторинга", Новый ОписаниеТипов("СправочникСсылка.ПоказателиМониторинга"));
	ТаблицаПоказателей.Колонки.Добавить("ГруппаОбъектовКонтроля", Новый ОписаниеТипов("Булево"));
	
	Для Каждого СтруктураПоказатель Из МассивСтруктурПоказателей Цикл
		
		Если ЗначениеЗаполнено(СтруктураПоказатель.Показатель) И СтруктураПоказатель.ТипПоказателя = "ПоказателиСчетчиков" Тогда
			
			НоваяСтрока							= ТаблицаПоказателей.Добавить();
			НоваяСтрока.ПоказательМониторинга	= СтруктураПоказатель.Показатель;
			НоваяСтрока.ГруппаОбъектовКонтроля	= СтруктураПоказатель.ГруппаОбъектовКонтроля;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	
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
	СтруктураДанныхГруппы.Вставить("Код", "Группы счетчиков");
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
	|	ГруппыСчетчиков.Код Как Код,
	|	ГруппыСчетчиков.Ссылка Как ГруппаСчетчиков,
	|	ЕСТЬNULL(ТаблицаПоказателей.ПоказательМониторинга, Неопределено) КАК ПоказательМониторинга
	|ИЗ
	|	Справочник.ГруппыСчетчиков КАК ГруппыСчетчиков
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПоказателиСчетчиков.Счетчики КАК ПоказателиСчетчиковСчетчики
	|
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаПоказателей КАК ТаблицаПоказателейОтбор
	|		ПО ТаблицаПоказателейОтбор.ПоказательМониторинга.Показатель = ПоказателиСчетчиковСчетчики.Ссылка
	|		И НЕ ТаблицаПоказателейОтбор.ГруппаОбъектовКонтроля
	|
	|	ПО ПоказателиСчетчиковСчетчики.Счетчик = ГруппыСчетчиков.Ссылка
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаПоказателей КАК ТаблицаПоказателей
	|	ПО ТаблицаПоказателей.ПоказательМониторинга.Показатель = ПоказателиСчетчиковСчетчики.Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ГруппыСчетчиков.ПолныйКодДляПоиска ИЕРАРХИЯ
	|";
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	ЗаполнитьМассивСчетчиковРекурсивно(МассивСтруктурыПоказателей, Выборка, ТолькоВыбранные);
	
	Возврат МассивСтруктурыПоказателей;
	
КонецФункции

Функция ПоискПоказателей(Знач СтрокаПоиска) Экспорт
	
	СтрокаПоиска = СтрЗаменить(СтрокаПоиска, """", "");
	
	МассивРезультатов = Новый Массив;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("СтрокаПоиска", "%" + СтрокаПоиска + "%");
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ГруппыСчетчиков.ПолныйКодДляПоиска Как Представление,
	|	ГруппыСчетчиков.Ссылка КАК ГруппаСчетчиков
	|ИЗ
	|	Справочник.ГруппыСчетчиков КАК ГруппыСчетчиков
	|ГДЕ
	|	ГруппыСчетчиков.ПолныйКодДляПоиска ПОДОБНО &СтрокаПоиска
	|	И НЕ ГруппыСчетчиков.Ссылка В (ВЫБРАТЬ Родитель ИЗ Справочник.ГруппыСчетчиков)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ГруппыСчетчиков.ПолныйКодДляПоиска
	|";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтруктураРезультата = Новый Структура();
		СтруктураРезультата.Вставить("Представление", Выборка.Представление);
		СтруктураРезультата.Вставить("ОбъектКонтроля", Выборка.ГруппаСчетчиков);
		СтруктураРезультата.Вставить("ТипПоказателя", "ПоказателиСчетчиков");
		
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
	|	Справочник.ПоказателиСчетчиков
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

#КонецОбласти

#КонецЕсли