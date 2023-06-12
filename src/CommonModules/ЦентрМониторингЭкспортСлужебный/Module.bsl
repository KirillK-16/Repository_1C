
#Область ПрограммныйИнтерфейс

// Передает настройки взаимодействия сервиса с клиентами центра мониторинга.
//	Параметры:
//		ВидыНастроек - Структура - флаги настроек, которые необходимо передать. Доступные флаги:
//			ИнформацияОТребуемыхДампах - Булево - передавать настройки о запрошенных дампах.
//			ТочечныеОтветы - Булево - передавать настройки точечных ответов.
//			ПравилаСвойствСообщений - Булево - передавать настройки правил свойств сообщений.
//
Процедура ПередатьНастройки(ВидыНастроек, РезультатОтправки = "") Экспорт
	
	НастройкиПолученияПолныхДампов = Константы.НастройкиПолученияПолныхДампов.Получить().Получить();
	Если НастройкиПолученияПолныхДампов = Неопределено Тогда
		РезультатОтправки = НСтр("ru = 'Не установлены параметры для передачи настроек'");
	КонецЕсли;
	ПараметрыПодключения = ПараметрыПодключения(НастройкиПолученияПолныхДампов.АдресСервиса);
	АдресРесурса = ?(Прав(ПараметрыПодключения.ПутьНаСервере,1) = "/", ПараметрыПодключения.ПутьНаСервере, ПараметрыПодключения.ПутьНаСервере + "/") + "PutInfo";
	ДанныеЗапроса = НастройкиДляПередачи(ВидыНастроек);
	СтрокаJSON = ДанныеЗапроса.Содержимое;
	Если ДанныеЗапроса.ВсегоНастроек <> 0 Тогда
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
			Если ВидыНастроек.ИнформацияОТребуемыхДампах Тогда
				ДампыЗапрошены();
			КонецЕсли;
			Если ВидыНастроек.ТочечныеОтветы Тогда
				КонтактыЗапрошены();
			КонецЕсли;
			РезультатОтправки =  НСтр("ru = 'Данные успешно отправлены.'");
		Иначе
			ШаблонСтроки = Нстр("ru = 'Ошибка HTTP %1. Описание: %2'");
			ТекстОшибки = СтрШаблон(ШаблонСтроки, HTTPОтвет.КодСостояния, HTTPОтвет.Тело); 		
			ЗаписьЖурналаРегистрации("ПередачаНастроек.PutInfo", УровеньЖурналаРегистрации.Ошибка, Метаданные.РегистрыСведений.ЗапрошенныеДампы, , ТекстОшибки);
			РезультатОтправки = ТекстОшибки;
		КонецЕсли;
	Иначе
		РезультатОтправки = НСтр("ru = 'Нет данных для отправки'");
	КонецЕсли;
	
КонецПроцедуры
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НастройкиДляПередачи(ВидыНастроек)
	JSONСтруктура = Новый Структура;
	ВсегоНастроек = 0;
	
	Если ВидыНастроек.ИнформацияОТребуемыхДампах Тогда
		ИнформацияОТребуемыхДампах = ИнформацияОТребуемыхДампах();
		ВсегоНастроек = ВсегоНастроек + ИнформацияОТребуемыхДампах.Количество();
		JSONСтруктура.Вставить("InfoAboutDemandedDumps", ИнформацияОТребуемыхДампах);
	КонецЕсли;
	Если ВидыНастроек.ТочечныеОтветы Тогда
		ПерсональныеОтветы = ПерсональныеОтветы(ВидыНастроек.ИнформацияОТребуемыхДампах);
		ВсегоНастроек = ВсегоНастроек + ПерсональныеОтветы.Количество();
		JSONСтруктура.Вставить("PointResponses", ПерсональныеОтветы);
	КонецЕсли;
	Если ВидыНастроек.ПравилаСвойствСообщений Тогда
		ОтветыПоПравилам = ОтветыПоПравилам();
		ВсегоНастроек = ВсегоНастроек + ОтветыПоПравилам.Количество();
		JSONСтруктура.Вставить("MessagePropertyRules", ОтветыПоПравилам);
	КонецЕсли;
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку(Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет));
	ЗаписатьJSON(ЗаписьJSON, JSONСтруктура);
	
	Структура = Новый Структура;
	Структура.Вставить("Содержимое", ЗаписьJSON.Закрыть());
	Структура.Вставить("ВсегоНастроек", ВсегоНастроек);
	
	Возврат Структура;
КонецФункции

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

#Область ИнформацияОТребуемыхДампах

Функция ИнформацияОТребуемыхДампах()
	
	МассивДампов = Новый Массив;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ЗапрошенныеДампы.ВариантДампа.Наименование КАК VariantOfDump,
	                      |	МАКСИМУМ(ЗапрошенныеДампы.ТипДампа = ""0"") КАК Minidump,
	                      |	МАКСИМУМ(ЗапрошенныеДампы.ТипДампа = ""3"") КАК Fulldump
	                      |ИЗ
	                      |	РегистрСведений.ЗапрошенныеДампы КАК ЗапрошенныеДампы
	                      |ГДЕ
	                      |	НЕ ЗапрошенныеДампы.Получен
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	ЗапрошенныеДампы.ВариантДампа.Наименование");
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеДампа = Новый Структура("VariantOfDump, Minidump, Fulldump");
		ЗаполнитьЗначенияСвойств(ДанныеДампа, Выборка);
		МассивДампов.Добавить(ДанныеДампа);
	КонецЦикла;
	
	Возврат МассивДампов;
	
КонецФункции

Процедура ДампыЗапрошены()
	НачатьТранзакцию();
	Попытка
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	ЗапрошенныеДампы.ИнформационнаяБаза КАК ИнформационнаяБаза,
		                      |	ЗапрошенныеДампы.ВариантДампа КАК ВариантДампа,
		                      |	ЗапрошенныеДампы.ТипДампа КАК ТипДампа,
		                      |	ЗапрошенныеДампы.ДатаЗапроса КАК ДатаЗапроса
		                      |ИЗ
		                      |	РегистрСведений.ЗапрошенныеДампы КАК ЗапрошенныеДампы
		                      |ГДЕ
		                      |	НЕ ЗапрошенныеДампы.Получен");
		РезультатЗапроса = Запрос.Выполнить();
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			Запись = РегистрыСведений.ЗапрошенныеДампы.СоздатьМенеджерЗаписи();
			Запись.ИнформационнаяБаза = Выборка.ИнформационнаяБаза;
			Запись.ВариантДампа = Выборка.ВариантДампа;
			Запись.ТипДампа = Выборка.ТипДампа;
			Запись.Прочитать();
			Запись.ДатаЗапроса = ?(ЗначениеЗаполнено(Выборка.ДатаЗапроса), Выборка.ДатаЗапроса, ТекущаяДатаСеанса());
			Запись.Запрошен = Истина;
			Запись.Записать();
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ОписаниеОшибки = ОписаниеОшибки();
		ЗаписьЖурналаРегистрации("ПередачаНастроек.ДампыЗапрошены", УровеньЖурналаРегистрации.Ошибка, Метаданные.РегистрыСведений.ЗапрошенныеДампы, , ОписаниеОшибки);
	КонецПопытки;

КонецПроцедуры

#КонецОбласти

#Область ПерсональныеОтветы

Функция ПерсональныеОтветы(ВключатьИнформациюОДампах)
	
	ДатаЗапроса = ТекущаяУниверсальнаяДата();
	Если ВключатьИнформациюОДампах Тогда
		НастройкиПолученияПолныхДампов = Константы.НастройкиПолученияПолныхДампов.Получить().Получить();
		ДнейПолученияДампов = НастройкиПолученияПолныхДампов.ПериодСбораДампа;
		РезервМестаВыключен = НастройкиПолученияПолныхДампов.РезервМестаВыключен;
		РезервМестаВключен = НастройкиПолученияПолныхДампов.РезервМестаВключен;
		ОкончаниеСбораДампов = Формат(НачалоДня(ДатаЗапроса + ДнейПолученияДампов * 86400), "ДФ=ггггММддЧЧммсс");
	КонецЕсли;
	
	МассивОтветов = Новый Массив;
	ОтветыИнформационныхБаз = Новый Соответствие;
	
	// Контакты информационных баз.
	Запрос = Новый Запрос(ТекстЗапроса_КонтактыИнформационныхБаз());
	Запрос.УстановитьПараметр("ДатаЗапроса", Дата(1,1,1));
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ОтветыИнформационныхБаз[Выборка.ИнформационнаяБаза] = Неопределено Тогда
			ОтветыИнформационныхБаз.Вставить(Выборка.ИнформационнаяБаза, Новый Структура);
		КонецЕсли;
		СтруктураОтвета = ОтветыИнформационныхБаз[Выборка.ИнформационнаяБаза];
		СтруктураОтвета.Вставить("ЗапросКонтактнойИнформации", Формат(3,"ЧН=0; ЧГ=0")); // 3 - необходимо запросить контактную информацию.
	КонецЦикла;
		
	// Запрошенные дампы.
	Если ВключатьИнформациюОДампах Тогда
		Запрос = Новый Запрос(ТекстЗапроса_ЗапрошенныеДампы());
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Если ОтветыИнформационныхБаз[Выборка.ИнформационнаяБаза] = Неопределено Тогда
				ОтветыИнформационныхБаз.Вставить(Выборка.ИнформационнаяБаза, Новый Структура);
			КонецЕсли;
			СтруктураОтвета = ОтветыИнформационныхБаз[Выборка.ИнформационнаяБаза];
			СтруктураОтвета.Вставить("ВариантДампа", Выборка.ВариантДампа);
			СтруктураОтвета.Вставить("ОкончаниеСбораДампов", ОкончаниеСбораДампов);
			СтруктураОтвета.Вставить("РезервМестаВыключен", Формат(РезервМестаВыключен,"ЧН=0; ЧГ=0"));
			СтруктураОтвета.Вставить("РезервМестаВключен", Формат(РезервМестаВключен,"ЧН=0; ЧГ=0"));
		КонецЦикла;
	КонецЕсли;
	
	ШаблонПараметра = "%1=%2";
	Для Каждого Запись Из ОтветыИнформационныхБаз Цикл
		МассивСтрок = Новый Массив;
		СтруктураОтвета = Запись.Значение;		
		Для Каждого ЗаписьПараметров Из СтруктураОтвета Цикл
			МассивСтрок.Добавить(СтрШаблон(ШаблонПараметра, ЗаписьПараметров.Ключ, ЗаписьПараметров.Значение));
		КонецЦикла;
		
		СтрокаПараметров = СтрСоединить(МассивСтрок, ";");
		
		ПерсональныйОтвет = Новый Структура;
		ПерсональныйОтвет.Вставить("Guid", Запись.Ключ);
		ПерсональныйОтвет.Вставить("Response", СтрокаПараметров);
		МассивОтветов.Добавить(ПерсональныйОтвет);
	КонецЦикла;
	
	Возврат МассивОтветов;
	
КонецФункции

Функция ТекстЗапроса_КонтактыИнформационныхБаз()
	Возврат "ВЫБРАТЬ
	|	КонтактыИнформационныхБаз.ИнформационнаяБаза.УникальныйИдентификатор КАК ИнформационнаяБаза,
	|	КонтактыИнформационныхБаз.ОтветНаЗапрос КАК ОтветНаЗапрос
	|ИЗ
	|	РегистрСведений.КонтактыИнформационныхБаз КАК КонтактыИнформационныхБаз
	|ГДЕ
	|	КонтактыИнформационныхБаз.ОтветНаЗапрос = 3"
КонецФункции
			
	
Функция ТекстЗапроса_ЗапрошенныеДампы()
		Возврат "ВЫБРАТЬ
		        |	ЗапрошенныеДампы.ИнформационнаяБаза.УникальныйИдентификатор КАК ИнформационнаяБаза,
		        |	ЗапрошенныеДампы.ВариантДампа.Наименование КАК ВариантДампа
		        |ИЗ
		        |	РегистрСведений.ЗапрошенныеДампы КАК ЗапрошенныеДампы
		        |ГДЕ
		        |	НЕ ЗапрошенныеДампы.Получен
		        |
		        |СГРУППИРОВАТЬ ПО
		        |	ЗапрошенныеДампы.ИнформационнаяБаза.УникальныйИдентификатор,
		        |	ЗапрошенныеДампы.ВариантДампа.Наименование"
КонецФункции	

Процедура КонтактыЗапрошены()
	НачатьТранзакцию();
	Попытка
		Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	КонтактыИнформационныхБаз.ИнформационнаяБаза КАК ИнформационнаяБаза,
	                      |	КонтактыИнформационныхБаз.ДатаЗапроса КАК ДатаЗапроса
	                      |ИЗ
	                      |	РегистрСведений.КонтактыИнформационныхБаз КАК КонтактыИнформационныхБаз
	                      |ГДЕ
	                      |	КонтактыИнформационныхБаз.ОтветНаЗапрос = 3");
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Запись = РегистрыСведений.КонтактыИнформационныхБаз.СоздатьМенеджерЗаписи();
			Запись.ИнформационнаяБаза = Выборка.ИнформационнаяБаза;
			Запись.Прочитать();
			Запись.ДатаЗапроса = ?(ЗначениеЗаполнено(Выборка.ДатаЗапроса), Выборка.ДатаЗапроса, ТекущаяДатаСеанса());
			Запись.Записать();
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ОписаниеОшибки = ОписаниеОшибки();
		ЗаписьЖурналаРегистрации("ПередачаНастроек.КонтактыЗапрошены", УровеньЖурналаРегистрации.Ошибка, Метаданные.РегистрыСведений.КонтактыИнформационныхБаз, , ОписаниеОшибки);
	КонецПопытки;	
КонецПроцедуры

#КонецОбласти

#Область ОтветыПоПравилам

Функция ОтветыПоПравилам()
	
	МассивПравил = Новый Массив;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ПРЕДСТАВЛЕНИЕ(ПравилаСвойствСообщений.GUID) КАК RuleID,
	                      |	ПравилаСвойствСообщений.Условия КАК Condition,
	                      |	ПравилаСвойствСообщений.Значение КАК Value
	                      |ИЗ
	                      |	РегистрСведений.ПравилаСвойствСообщений КАК ПравилаСвойствСообщений
	                      |ГДЕ
	                      |	ПравилаСвойствСообщений.Активно");
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеПравила = Новый Структура("RuleID, Condition, Value");
		ЗаполнитьЗначенияСвойств(ДанныеПравила, Выборка);
		МассивПравил.Добавить(ДанныеПравила);
	КонецЦикла;
	
	Возврат МассивПравил;
	
КонецФункции

#КонецОбласти

#КонецОбласти