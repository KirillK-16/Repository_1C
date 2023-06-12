
Процедура ПолучитьИнформациюОЗапрошенныхДампахРегламентноеЗадание() Экспорт
	
	Общий.ПриНачалеВыполненияРегламентногоЗадания();
	
	ПолучитьИнформациюОЗапрошенныхДампах();
	
КонецПроцедуры                             

// Получает информацию о полученных дампах из http-сервиса GetInfoAboutReceivedDumps.
// Дампы перемещаются из каталога в каталог.
// Результат пишется в регистр сведений "ПолученныеДампы".
//
Процедура ПолучитьИнформациюОЗапрошенныхДампах() Экспорт
	ПараметрыПолучения = Константы.НастройкиПолученияПолныхДампов.Получить().Получить();
	Если ПараметрыПолучения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПараметрыПодключения = ПараметрыПодключения(ПараметрыПолучения.АдресСервиса);
	АдресРесурса = ?(Прав(ПараметрыПодключения.ПутьНаСервере,1) = "/", ПараметрыПодключения.ПутьНаСервере, ПараметрыПодключения.ПутьНаСервере + "/") + "GetInfoAboutReceivedDumps";
	
	ПараметрыHTTP = Новый Структура;
	ПараметрыHTTP.Вставить("Сервер", ПараметрыПодключения.Хост);
	ПараметрыHTTP.Вставить("АдресРесурса", АдресРесурса);
	ПараметрыHTTP.Вставить("Пользователь", ПараметрыПолучения.Логин);
	ПараметрыHTTP.Вставить("Пароль", ПараметрыПолучения.Пароль);
	ПараметрыHTTP.Вставить("Данные", "");
	ПараметрыHTTP.Вставить("Порт", ПараметрыПодключения.Порт);
	ПараметрыHTTP.Вставить("ЗащищенноеСоединение", ПараметрыПодключения.ЗащищенноеСоединение);	
	ПараметрыHTTP.Вставить("Метод", "GET");
	ПараметрыHTTP.Вставить("ТипДанных", "");
	ПараметрыHTTP.Вставить("Таймаут", 60);
	
	ОписаниеЧисло = Новый ОписаниеТипов("Число");
	HTTPОтвет = HTTPСервисОтправитьДанныеСлужебный(ПараметрыHTTP);
	Если HTTPОтвет.КодСостояния = 200 Тогда
		МассивJSON = СтрокаJSONВСтруктуру(HTTPОтвет.Тело);
		РазделительПути = ПолучитьРазделительПути();
		
		Для Каждого Элемент Из МассивJSON Цикл
			Если Прав(Элемент.RelativePath, 1) <> РазделительПути Тогда
				Элемент.RelativePath = Элемент.RelativePath + РазделительПути;
			КонецЕсли;
			ИмяФайла = Элемент.RelativePath + Элемент.DumpName;
			Попытка
				ИнформационнаяБаза = Справочники.ИнформационныеБазы.НайтиПоРеквизиту("УникальныйИдентификатор", Элемент.GUID);
				ВариантДампа = Справочники.ВариантыДамповЦентрМониторинга.НайтиПоНаименованию(Элемент.DumpVariant, Истина);
				
				// Запишем результат перемещения.
				НачатьТранзакцию();
				
				ТипДампа = ?(Элемент.Свойство("DumpType"), Элемент.DumpType, "3");
				ЗаписьРС = РегистрыСведений.ПолученныеДампы.СоздатьМенеджерЗаписи();
				ЗаписьРС.Период = Дата(Элемент.SaveDate);
				ЗаписьРС.ВариантДампа = ВариантДампа;
				ЗаписьРС.ИнформационнаяБаза = ИнформационнаяБаза;
				ЗаписьРС.ИмяДампа = Элемент.DumpName;
				ЗаписьРС.ЛокальныйПуть = ИмяФайла;
				ЗаписьРС.ТипДампа = ТипДампа;
				ЗаписьРС.Записать();
				
				ЗапрошенныеДампы = РегистрыСведений.ЗапрошенныеДампы.СоздатьНаборЗаписей();
				ЗапрошенныеДампы.Отбор.ВариантДампа.Установить(ВариантДампа);
				ЗапрошенныеДампы.Отбор.ТипДампа.Установить(ТипДампа);
				ЗапрошенныеДампы.Прочитать();
				Для Каждого ЗаписьЗапрошенные Из ЗапрошенныеДампы Цикл
					ЗаписьЗапрошенные.Получен = Истина;
				КонецЦикла;
				ЗапрошенныеДампы.Записать();
				
			Исключение
				ОтменитьТранзакцию();
				ОписаниеОшибки = ОписаниеОшибки();
				ШаблонСтроки = Нстр("ru = 'Ошибка при загрузке информации о полученных дампах.
				|Причина: %1'");
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСтроки, ОписаниеОшибки); 		
				ЗаписьЖурналаРегистрации("ПолныеДампы.ПолучениеЗапрошенныхДампов", УровеньЖурналаРегистрации.Ошибка, Метаданные.РегистрыСведений.ПолученныеДампы, , ТекстОшибки);
			КонецПопытки; 	
			
			ЗафиксироватьТранзакцию();
			
		КонецЦикла;
		
	Иначе
		ШаблонСтроки = Нстр("ru = 'Ошибка HTTP %1. Описание: %2'");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСтроки, HTTPОтвет.КодСостояния, HTTPОтвет.Тело); 		
		ЗаписьЖурналаРегистрации("ПолныеДампы.ПолучениеЗапрошенныхДампов", УровеньЖурналаРегистрации.Ошибка, Метаданные.РегистрыСведений.ЗапрошенныеДампы, , ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры

// Передает информацию о необходимых дампах в http-сервис PutInfoAboutDemandedDumps.
// Данные берутся из регистра сведений "ЗапрошенныеДампы".
// В случае успешной отправки данных (OK 200) помечает отправленные дампы как запрошенные.
//
Функция ПоместитьИнформациюОНеобходимыхДампах() Экспорт 
	НастройкиПолученияПолныхДампов = Константы.НастройкиПолученияПолныхДампов.Получить().Получить();
	Если НастройкиПолученияПолныхДампов = Неопределено Тогда
		Возврат НСтр("ru = 'Не установлены настройки получения полных дампов'");
	КонецЕсли;
	ПараметрыПодключения = ПараметрыПодключения(НастройкиПолученияПолныхДампов.АдресСервиса);
	АдресРесурса = ?(Прав(ПараметрыПодключения.ПутьНаСервере,1) = "/", ПараметрыПодключения.ПутьНаСервере, ПараметрыПодключения.ПутьНаСервере + "/") + "PutInfoAboutDemandedDumps";
	ДанныеЗапроса = ЗапрошенныеДампы();
	СтрокаJSON = ДанныеЗапроса.Содержимое;
	Если СтрокаJSON <> Неопределено Тогда
		ПараметрыHTTP = Новый Структура;
		ПараметрыHTTP.Вставить("Сервер", ПараметрыПодключения.Хост);
		ПараметрыHTTP.Вставить("АдресРесурса", АдресРесурса);
		ПараметрыHTTP.Вставить("Пользователь", НастройкиПолученияПолныхДампов.Логин);
		ПараметрыHTTP.Вставить("Пароль", НастройкиПолученияПолныхДампов.Пароль);
		ПараметрыHTTP.Вставить("Данные", СтрокаJSON);
		ПараметрыHTTP.Вставить("Порт", ПараметрыПодключения.Порт);
		ПараметрыHTTP.Вставить("ЗащищенноеСоединение", ПараметрыПодключения.ЗащищенноеСоединение);	
		ПараметрыHTTP.Вставить("Метод", "POST");
		ПараметрыHTTP.Вставить("ТипДанных", "Текст");
		ПараметрыHTTP.Вставить("Таймаут", 60);
		HTTPОтвет = HTTPСервисОтправитьДанныеСлужебный(ПараметрыHTTP);
		Если HTTPОтвет.КодСостояния = 200 Тогда
			ДампыЗапрошены();
			Возврат НСтр("ru = 'Данные успешно отправлены. Запрошено: '") + Формат(ДанныеЗапроса.ВсегоЗапрошено,"ЧН=0; ЧГ=");
		Иначе
			ШаблонСтроки = Нстр("ru = 'Ошибка HTTP %1. Описание: %2'");
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСтроки, HTTPОтвет.КодСостояния, HTTPОтвет.Тело); 		
			ЗаписьЖурналаРегистрации("ПолныеДампы.ЗапросДамповКлиентов", УровеньЖурналаРегистрации.Ошибка, Метаданные.РегистрыСведений.ЗапрошенныеДампы, , ТекстОшибки);
			Возврат ТекстОшибки;
		КонецЕсли;
	Иначе
		Возврат НСтр("ru = 'Нет данных для отправки'");
	КонецЕсли;
КонецФункции

#Область СлужебныеПроцедурыИФункции

Функция ПараметрыПодключения(АдресСервиса)
	ПараметрыПодключения = Новый Структура;
	ПараметрыПодключения = ОбщегоНазначенияКлиентСервер.СтруктураURI(АдресСервиса);
	
	
	Если ПараметрыПодключения.Схема = "http" Тогда
		ПараметрыПодключения.Вставить("ЗащищенноеСоединение", Ложь);
	ИначеЕсли ПараметрыПодключения.Схема = "https" Тогда
		ПараметрыПодключения.Вставить("ЗащищенноеСоединение", Истина);
	Иначе
		ПараметрыПодключения.Вставить("ЗащищенноеСоединение", Ложь);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПараметрыПодключения.Порт) Тогда
		Если ПараметрыПодключения.Схема = "http" Тогда
			ПараметрыПодключения.Порт = 80;
		ИначеЕсли ПараметрыПодключения.Схема = "https" Тогда
			ПараметрыПодключения.Порт = 443;
		Иначе
			ПараметрыПодключения.Порт = 80;
		КонецЕсли;
	КонецЕсли;    	
	
	Возврат ПараметрыПодключения;	
КонецФункции

Функция ЗапрошенныеДампы()
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ЗапрошенныеДампы.ИнформационнаяБаза.Наименование КАК ИнформационнаяБаза,
	                      |	ЗапрошенныеДампы.ВариантДампа.Наименование КАК ВариантДампа
	                      |ИЗ
	                      |	РегистрСведений.ЗапрошенныеДампы КАК ЗапрошенныеДампы
	                      |ГДЕ
	                      |	НЕ ЗапрошенныеДампы.Получен
	                      |	И ЗапрошенныеДампы.ТипДампа = ""3""");
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	Выборка = РезультатЗапроса.Выбрать();
	ВсегоЗапрошено = Выборка.Количество();
	// GUID - ИдентификаторИБ
	// DumpVariant - ВариантДампа
	JSON = Новый Массив;
	Пока Выборка.Следующий() Цикл
		Запись = Новый Структура;
		Запись.Вставить("GUID", Выборка.ИнформационнаяБаза);
		Запись.Вставить("DumpVariant", Выборка.ВариантДампа);
		JSON.Добавить(Запись);
	КонецЦикла;
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку(Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет));
	ЗаписатьJSON(ЗаписьJSON, JSON);
	Структура = Новый Структура;
	Структура.Вставить("Содержимое", ЗаписьJSON.Закрыть());
	Структура.Вставить("ВсегоЗапрошено", ВсегоЗапрошено);
	
	Возврат Структура;
КонецФункции

Процедура ДампыЗапрошены()
	НачатьТранзакцию();
	Попытка
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	ЗапрошенныеДампы.ИнформационнаяБаза КАК ИнформационнаяБаза,
		                      |	ЗапрошенныеДампы.ВариантДампа КАК ВариантДампа,
		                      |	ЗапрошенныеДампы.ДатаЗапроса КАК ДатаЗапроса
		                      |ИЗ
		                      |	РегистрСведений.ЗапрошенныеДампы КАК ЗапрошенныеДампы
		                      |ГДЕ
		                      |	НЕ ЗапрошенныеДампы.Получен
		                      |	И ЗапрошенныеДампы.ТипДампа = ""3""");
		РезультатЗапроса = Запрос.Выполнить();
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			Запись = РегистрыСведений.ЗапрошенныеДампы.СоздатьМенеджерЗаписи();
			Запись.ИнформационнаяБаза = Выборка.ИнформационнаяБаза;
			Запись.ВариантДампа = Выборка.ВариантДампа;
			Запись.Прочитать();
			Запись.ДатаЗапроса = ?(ЗначениеЗаполнено(Выборка.ДатаЗапроса), Выборка.ДатаЗапроса, ТекущаяДатаСеанса());
			Запись.Запрошен = Истина;
			Запись.Записать();
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ОписаниеОшибки = ОписаниеОшибки();
		ЗаписьЖурналаРегистрации("ПолныеДампы.ЗапросДамповКлиентов", УровеньЖурналаРегистрации.Ошибка, Метаданные.РегистрыСведений.ЗапрошенныеДампы, , ОписаниеОшибки);
	КонецПопытки;

КонецПроцедуры

Функция HTTPСервисОтправитьДанныеСлужебный(Параметры)
	Если Параметры.ЗащищенноеСоединение Тогда
		HTTPСоединение = Новый HTTPСоединение(Параметры.Сервер, Параметры.Порт, Параметры.Пользователь, Параметры.Пароль,,Параметры.Таймаут, Новый ЗащищенноеСоединениеOpenSSL(Неопределено, Неопределено));
	Иначе
		HTTPСоединение = Новый HTTPСоединение(Параметры.Сервер, Параметры.Порт, Параметры.Пользователь, Параметры.Пароль,,Параметры.Таймаут);
	КонецЕсли;
		
	HTTPЗапрос = Новый HTTPЗапрос(Параметры.АдресРесурса);
	
	Если Параметры.ТипДанных = "Текст" Тогда
		HTTPЗапрос.УстановитьТелоИзСтроки(Параметры.Данные);
	ИначеЕсли Параметры.ТипДанных = "ДвоичныеДанные" Тогда
		ДвоичныеДанныеАрхива = Новый ДвоичныеДанные(Параметры.Данные);
		HTTPЗапрос.УстановитьТелоИзДвоичныхДанных(ДвоичныеДанныеАрхива);
	КонецЕсли;
	
	Попытка
		Если Параметры.Метод = "POST" Тогда
			HTTPОтвет = HTTPСоединение.ОтправитьДляОбработки(HTTPЗапрос);
		ИначеЕсли Параметры.Метод = "GET" Тогда
			HTTPОтвет = HTTPСоединение.Получить(HTTPЗапрос);
		КонецЕсли;
		
		Если Параметры.ТипДанных = "ДвоичныеДанные" Тогда
			УдалитьФайлы(Параметры.Данные);
		КонецЕсли;
		
		HTTPОтветСтруктура = HTTPОтветВСтруктуру(HTTPОтвет);
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		HTTPОтветСтруктура = Новый Структура("КодСостояния, Тело", 105, ОписаниеОшибки);
	КонецПопытки;
	
	Возврат HTTPОтветСтруктура;
КонецФункции

Функция HTTPОтветВСтруктуру(Ответ)
	Результат = Новый Структура;
	
	Результат.Вставить("КодСостояния", Ответ.КодСостояния);
	Результат.Вставить("Заголовки",  Новый Соответствие);
	Для каждого Параметр Из Ответ.Заголовки Цикл
		Результат.Заголовки.Вставить(Параметр.Ключ, Параметр.Значение);
	КонецЦикла;
	
	Если Ответ.Заголовки["Content-Type"] <> Неопределено Тогда
		ContentType = Ответ.Заголовки["Content-Type"];
		Если СтрНайти(ContentType, "text/plain") > 0 Тогда
			Тело = Ответ.ПолучитьТелоКакСтроку();
			Результат.Вставить("Тело", Тело);
		ИначеЕсли СтрНайти(ContentType, "text/html") > 0 Тогда
			Тело = Ответ.ПолучитьТелоКакСтроку();
			Результат.Вставить("Тело", Тело);
		ИначеЕсли СтрНайти(ContentType, "application/json") Тогда
			Тело = Ответ.ПолучитьТелоКакСтроку();
			Результат.Вставить("Тело", Тело);
		Иначе
			Тело = "Не известный ContentType = " + ContentType + ". См. <Функция HTTPОтветВСтруктуру(Ответ) Экспорт>";
			Результат.Вставить("Тело", Тело);
		КонецЕсли;
	Иначе
		Результат.Вставить("Тело", "");
	КонецЕсли;	
	
	Возврат Результат;
КонецФункции

Функция СтрокаJSONВСтруктуру(СтрокаJSON)
	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.УстановитьСтроку(СтрокаJSON);
	
	СтруктураJSON = ПрочитатьJSON(ЧтениеJSON);
	
	Возврат СтруктураJSON;
КонецФункции

#КонецОбласти