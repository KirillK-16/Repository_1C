
#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Считывание параметров передачи.
	ПараметрыПередачи 				= ПолучитьИзВременногоХранилища(Параметры.АдресХранилища);
	Объект.Запросы.Загрузить(ПараметрыПередачи.Запросы);	
	Объект.Параметры.Загрузить(ПараметрыПередачи.Параметры);
	Объект.ИмяФайла 				= ПараметрыПередачи.ИмяФайла;
	ИдентификаторТекущегоЗапроса 	= ПараметрыПередачи.ИдентификаторТекущегоЗапроса;
	ИдентификаторТекущегоПараметра	= ПараметрыПередачи.ИдентификаторТекущегоПараметра;
	
	ОбработкаОбъект                 = ОбъектОбработки();
	Объект.ДоступныеТипыДанных		= ОбработкаОбъект.Метаданные().Реквизиты.ДоступныеТипыДанных.Тип;
	
	СписокТипов						= ОбъектОбработки().СформироватьСписокТипов();
	ОбработкаОбъект.ФильтрацияСпискаТипов(СписокТипов, "");
	
	Фильтр				= Новый Структура;
	Фильтр.Вставить("Идентификатор", ИдентификаторТекущегоЗапроса);
	СтрокиЗапросовСИдентификатор 	= Объект.Запросы.НайтиСтроки(Фильтр);
	Если СтрокиЗапросовСИдентификатор.Количество() > 0 Тогда 
		Элементы.Запросы.ТекущаяСтрока = СтрокиЗапросовСИдентификатор.Получить(0).ПолучитьИдентификатор();
	КонецЕсли;	  
	Заголовок = НСтр("ru = 'Выбрать запрос'");	
КонецПроцедуры

&НаКлиенте
Процедура ЗапросыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
	
	ЭлементКопирования = Элемент.ТекущиеДанные;
	
	ИмяЗапросаПоУмолчанию = ЭтотОбъект.ВладелецФормы.ИмяЗапросаПоУмолчанию;
	ИдентификаторЗапроса = Новый УникальныйИдентификатор;
	
	Запрос = Объект.Запросы.Добавить();
	Запрос.Имя = ИмяЗапросаПоУмолчанию;
	Запрос.Идентификатор = ИдентификаторЗапроса;
	
	Если Копирование Тогда
		ИмяНовогоЗапроса = СформироватьИмяКопииЗапроса(ЭлементКопирования.Имя);
		Запрос.Имя = ИмяНовогоЗапроса;
		Запрос.Текст = ЭлементКопирования.Текст;
		ИдентификаторТекущегоЗапроса = ЭлементКопирования.Идентификатор;
		
		// Копирование параметров
		Фильтр = Новый Структура;
		Фильтр.Вставить("ИдентификаторЗапроса", ИдентификаторТекущегоЗапроса);
		МассивПараметров = Объект.Параметры.НайтиСтроки(Фильтр);
		Для каждого Стр Из МассивПараметров Цикл
			ЭлементПараметр = Объект.Параметры.Добавить();
			ЭлементПараметр.Идентификатор = Новый УникальныйИдентификатор;
			ЭлементПараметр.ИдентификаторЗапроса = ИдентификаторЗапроса;
			ЭлементПараметр.Имя = Стр.Имя;
			ЭлементПараметр.Тип = Стр.Тип;
			ЭлементПараметр.Значение = Стр.Значение;
			ЭлементПараметр.ТипВФорме = Стр.ТипВФорме;
			ЭлементПараметр.ЗначениеВФорме = Стр.ЗначениеВФорме;
		КонецЦикла;
	КонецЕсли;
	
	ВладелецФормы.Модифицированность = Истина;
КонецПроцедуры

// Обработчик перед удалением Запроса.
// Удаляет параметры для данного запроса.
//
&НаКлиенте
Процедура ЗапросыПередУдалением(Элемент, Отказ)
	ПараметрыВФорме = Объект.Параметры;
	ИдентификаторУдаляемогоЗапроса = Элементы.Запросы.ТекущиеДанные.Идентификатор;
	
	КоличествоСтрок = ПараметрыВФорме.Количество() - 1;
	Пока КоличествоСтрок >= 0 Цикл
		ТекущийПараметр = ПараметрыВФорме.Получить(КоличествоСтрок);
		Если ТекущийПараметр.ИдентификаторЗапроса = ИдентификаторУдаляемогоЗапроса Тогда
			ПараметрыВФорме.Удалить(КоличествоСтрок);
			Модифицированность = Истина;
		КонецЕсли;
		КоличествоСтрок = КоличествоСтрок - 1;
	КонецЦикла;
	
	ВладелецФормы.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗапросыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОбработкаВыбораЗапроса();	
КонецПроцедуры

&НаКлиенте
Процедура ЗапросыИмяПриИзменении(Элемент)
	ВладелецФормы.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СравнитьРезультатыЗапросов(Команда)
	#Если Не ВебКлиент И Не ТонкийКлиент Тогда
	ВыделенныеЗапросы = Элементы.Запросы.ВыделенныеСтроки;
	Если ВыделенныеЗапросы.Количество() <> 2 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Для сравнения необходимо выбрать только 2 запроса", "Объект'"));
		Возврат;
	Иначе
		ИдентификаторСтрокиПервогоЗапроса = ВыделенныеЗапросы.Получить(0);
		ИдентификаторСтрокиВторогоЗапроса = ВыделенныеЗапросы.Получить(1);
	КонецЕсли;	
	
	ИдентификаторПервогоЗапроса = Объект.Запросы.НайтиПоИдентификатору(ИдентификаторСтрокиПервогоЗапроса).Идентификатор;
	ИдентификаторВторогоЗапроса = Объект.Запросы.НайтиПоИдентификатору(ИдентификаторСтрокиВторогоЗапроса).Идентификатор;
	
	ТабличныйДокументПервогоЗапроса = Неопределено;
	ТабличныйДокументВторогоЗапроса = Неопределено;
	
	ПолучитьТабличныеДокументыСравниваемыхЗапросов(ИдентификаторПервогоЗапроса, ИдентификаторВторогоЗапроса, ТабличныйДокументПервогоЗапроса, ТабличныйДокументВторогоЗапроса);
	
	Если ТипЗнч(ТабличныйДокументПервогоЗапроса) <> Неопределено
		И ТипЗнч(ТабличныйДокументВторогоЗапроса) <> Неопределено Тогда
		// Сравниваются два файла.
		Сравнение = Новый СравнениеФайлов;
		Сравнение.СпособСравнения = СпособСравненияФайлов.ТабличныйДокумент;
		Сравнение.ПервыйФайл = ТабличныйДокументПервогоЗапроса;
		Сравнение.ВторойФайл = ТабличныйДокументВторогоЗапроса;
		Сравнение.ПоказатьРазличияМодально();
	КонецЕсли;
	#Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Сравнивать результаты можно только в режиме толстого клиента.", "Объект'"));
	#КонецЕсли
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////
// ОБЩИЕ КОМАНДЫ

&НаКлиенте
Процедура СохранитьЗапросыВФайл(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("УстановитьИмяФайлаЗапроса", ЭтотОбъект, Объект.ИмяФайла);
	СохранитьФайлЗапроса(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьЗапросыВДругойФайл(Команда)
	ОписаниеОповещения = Новый ОписаниеОповещения("УстановитьИмяФайлаЗапроса", ЭтотОбъект, "");
	СохранитьФайлЗапроса(ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИмяФайлаЗапроса(ИмяФайла, ДополнительныеПараметры) Экспорт
	
	Объект.ИмяФайла = ИмяФайла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьЗапросыИзФайла(Команда)
	ОбработкаЧтенияФайла(Истина);	
	ВладелецФормы.Модифицированность = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЗапрос(Команда)
	ОбработкаВыбораЗапроса();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЗапросыИзФайла(Команда)
	ОбработкаЧтенияФайла(Ложь);
	ВладелецФормы.Модифицированность = Истина;
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция ОбъектОбработки()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции

&НаСервере
Функция ПоместитьЗапросыВСтруктуру(ИдентификаторЗапроса, ИдентификаторПараметра)
	ПараметрыПередачи = Новый Структура;
	ПараметрыПередачи.Вставить("АдресХранилища", ОбъектОбработки().ПоместитьЗапросыВоВременноеХранилище(Объект, ИдентификаторЗапроса, ИдентификаторПараметра));
	Возврат ПараметрыПередачи;
КонецФункции	

// Сохранение запросов.
//
// Параметры:
//	ИмяФайла - имя файла XML.
//	Объект - объект обработки.
//
&НаСервере
Функция СохранитьЗапросы(знач Объект)
	
	ДвоичныеДанные = ОбъектОбработки().ЗаписатьЗапросыВФайлXML(Объект);
	Возврат ДвоичныеДанные;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаВыбораЗапроса()
	ТекущаяСтрока = Элементы.Запросы.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда 
		ТекущийЗапрос = Элементы.Запросы.ТекущиеДанные;
		ИдентификаторТекущегоЗапроса = ТекущийЗапрос.Идентификатор;
		ПараметрыПередачи = ПоместитьЗапросыВСтруктуру(ИдентификаторТекущегоЗапроса, ИдентификаторТекущегоПараметра);
		
		// Передача в открывающую форму.
		Закрыть(); 
		
		Оповестить("ВыгрузитьЗапросыВРеквизиты", ПараметрыПередачи);
		Оповестить("ОбновитьФормуКлиент");
	Иначе
		ПоказатьСообщениеПользователю(НСтр("ru = 'Выберите запрос.'"), "Объект");
	КонецЕсли;
КонецПроцедуры	

// Формирование диалога по сохранению файла запросов.
//
&НаКлиенте
Процедура СохранитьФайлЗапроса(ОписаниеОповещения)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СохранитьФайлЗапросаЗавершение", ЭтотОбъект, ОписаниеОповещения);
	#Если Не ВебКлиент Тогда
		// В тонком и толстом клиентах расширение подключено всегда.
		СохранитьФайлЗапросаЗавершение(ОписаниеОповещения);
		Возврат;
	#КонецЕсли
	
	ОписаниеОповещенияПодключитьРасширениеРаботыСФайлами = Новый ОписаниеОповещения("СохранитьФайлЗапросаНачатьПодключениеРасширенияРаботыСФайламиЗавершение", ЭтотОбъект, ОписаниеОповещения);
	НачатьПодключениеРасширенияРаботыСФайлами(ОписаниеОповещенияПодключитьРасширениеРаботыСФайлами);
	
	Если Не ЗаданВопросОбУстановкеРасширения Тогда
		
		ЗаданВопросОбУстановкеРасширения = Истина;
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("ЗадатьВопросОбУстановкеРасширения", ЭтотОбъект, ОписаниеОповещения);
		ПоказатьВопрос(ОписаниеОповещенияВопрос, Нстр("ru = 'Установить расширение для работы с файлами?'"), РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		СохранитьФайлЗапросаЗавершение(ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьФайлЗапросаНачатьПодключениеРасширенияРаботыСФайламиЗавершение(Подключено, ДополнительныеПараметры) Экспорт
	
	Если Подключено Тогда
		СохранитьФайлЗапросаЗавершение(ДополнительныеПараметры);
	Иначе
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("ЗадатьВопросОбУстановкеРасширения", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(ОписаниеОповещенияВопрос, Нстр("ru = 'Установить расширение для работы с файлами?'"), РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьВопросОбУстановкеРасширения(Ответ, Оповещение) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		НачатьУстановкуРасширенияРаботыСФайлами(Оповещение);
		
	Иначе
		
		СохранитьФайлЗапросаЗавершение(Оповещение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьФайлЗапросаЗавершение(Оповещение) Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СохранитьФайлЗапросаЗавершениеНачатьПодключениеРасширенияРаботыСФайламиЗавершение", ЭтотОбъект, Оповещение);
	НачатьПодключениеРасширенияРаботыСФайлами(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьФайлЗапросаЗавершениеНачатьПодключениеРасширенияРаботыСФайламиЗавершение(Подключено, ДополнительныеПараметры) Экспорт
	
	ИмяФайла = ДополнительныеПараметры.ДополнительныеПараметры;
	
	Если Подключено Тогда
		Если ПустаяСтрока(ИмяФайла) Тогда
			Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
			Диалог.Заголовок					= НСтр("ru = 'Выберите файл запросов'");
			Диалог.ПредварительныйПросмотр  	= Ложь;
			Диалог.Фильтр   					= НСтр("ru = 'Файл запросов (*.q1c)|*.q1c'");
			Диалог.Расширение   				= "q1c";
			Диалог.ПроверятьСуществованиеФайла  = Истина;
			Диалог.МножественныйВыбор			= Ложь;
			
			ОписаниеОповещения = Новый ОписаниеОповещения("СохранитьФайлЗапросаЗавершениеНачатьПодключениеРасширенияРаботыСФайламиЗавершениеДиалогПоказатьЗавершение", ЭтотОбъект, ИмяФайла);
			Диалог.Показать(ОписаниеОповещения);
		Иначе
			СохранитьФайлЗапросаЗавершениеНачатьПодключениеРасширенияРаботыСФайламиЗавершениеДиалогПоказатьОбщая(ИмяФайла);
		КонецЕсли;
	Иначе
		ТекстСообщения = НСтр("ru = 'В данном браузере невозможно работать с файлами.'");
		ПоказатьСообщениеПользователю(ТекстСообщения, "Объект");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьФайлЗапросаЗавершениеНачатьПодключениеРасширенияРаботыСФайламиЗавершениеДиалогПоказатьЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено Тогда
		ИмяФайла = ВыбранныеФайлы[0].ПолноеИмяФайла;
		СохранитьФайлЗапросаЗавершениеНачатьПодключениеРасширенияРаботыСФайламиЗавершениеДиалогПоказатьОбщая(ИмяФайла);
	КонецЕсли;
		
КонецПроцедуры


&НаКлиенте
Процедура СохранитьФайлЗапросаЗавершениеНачатьПодключениеРасширенияРаботыСФайламиЗавершениеДиалогПоказатьОбщая(ИмяФайла)
	
	Если Не ПустаяСтрока(ИмяФайла) Тогда 
		ДвоичныеДанные = СохранитьЗапросы(Объект);
		ДвоичныеДанные.Записать(ИмяФайла);
		ВладелецФормы.Модифицированность = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаЧтенияФайла(Удалять)
	
	// Выбор файла для загрузки.
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок = НСтр("ru = 'Выберите файл запросов'");
	Диалог.ПредварительныйПросмотр = Ложь;
	Диалог.Фильтр = НСтр("ru = 'Файл запросов (*.q1c)|*.q1c'");
	Диалог.Расширение = "q1c";
	Диалог.ПроверятьСуществованиеФайла  = Истина;
	Диалог.МножественныйВыбор = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаЧтенияФайлаЗаверешение", ЭтотОбъект, Удалять);
	Диалог.Показать(ОписаниеОповещения);
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЧтенияФайлаЗаверешение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено Тогда
		ИмяФайла = ВыбранныеФайлы[0].ПолноеИмяФайла;
		
		// Чтение данных из файла.
		Если Не ПустаяСтрока(ИмяФайла) Тогда
			Если ДополнительныеПараметры Тогда 
				Объект.Запросы.Очистить();
				Объект.Параметры.Очистить();
			КонецЕсли;	
			ДвоичныеДанные = Новый ДвоичныеДанные(ИмяФайла);
			ЗагрузитьЗапросыИзФайла(ДвоичныеДанные)
		КонецЕсли;
		Объект.ИмяФайла = ИмяФайла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьЗапросыИзФайла(ДвоичныеДанные)
	
	ОбъектВнешнейОбработки = ОбъектОбработки().ПрочитатьЗапросыИзФайлаXML(ДвоичныеДанные);
	ЗаполнитьЗапросыИПараметрыИзОбъектаВнешнейОбработки(ОбъектВнешнейОбработки);
	
КонецПроцедуры

// Заполняет из объекта внешней обработки запросы и параметры.
//
// Параметры:
//	ОбъектОбработки - объект внешней обработки.
//
&НаСервере
Процедура ЗаполнитьЗапросыИПараметрыИзОбъектаВнешнейОбработки(ОбъектОбработки)
	ЗапросыОбработка = ОбъектОбработки.Запросы;
	ПараметрыОбработка = ОбъектОбработки.Параметры;
	
	Объект.Запросы.Очистить();
	Объект.Параметры.Очистить();
	
	// Заполнение запросов и параметров в форме.
	Для каждого ТекстЗапрос Из ЗапросыОбработка Цикл
		ЭлементЗапроса = Объект.Запросы.Добавить();
		ЭлементЗапроса.Идентификатор = ТекстЗапрос.Идентификатор;
		ЭлементЗапроса.Имя = ТекстЗапрос.Имя;
		ЭлементЗапроса.Текст = ТекстЗапрос.Текст;
	КонецЦикла;
	
	Для каждого ТекПараметр Из ПараметрыОбработка Цикл
		ТипСтрока = ТекПараметр.Тип;
		
		Значение = ТекПараметр.Значение;
		Значение = ЗначениеИЗСтрокиВнутр(Значение);
		
		Если ТипСтрока = "ТаблицаЗначений" ИЛИ ТипСтрока = "МоментВремени" ИЛИ ТипСтрока = "Граница" Тогда
			ЭлементПараметр = Объект.Параметры.Добавить();
			ЭлементПараметр.ИдентификаторЗапроса = ТекПараметр.ИдентификаторЗапроса;
			ЭлементПараметр.Идентификатор = ТекПараметр.Идентификатор;
			ЭлементПараметр.Имя = ТекПараметр.Имя;
			ЭлементПараметр.Тип = СписокТипов.НайтиПоЗначению(ТипСтрока).Значение;
			ЭлементПараметр.Значение = ТекПараметр.Значение;
			ЭлементПараметр.ТипВФорме = СписокТипов.НайтиПоЗначению(ТипСтрока).Представление;
			ЭлементПараметр.ЗначениеВФорме = ОбъектОбработки().ФормированиеПредставленияЗначения(Значение);
		Иначе
			Массив = Новый Массив;
			Массив.Добавить(Тип(ТипСтрока));
			Описание = Новый ОписаниеТипов(Массив);
			
			ЭлементПараметр = Объект.Параметры.Добавить();
			ЭлементПараметр.ИдентификаторЗапроса = ТекПараметр.ИдентификаторЗапроса;
			ЭлементПараметр.Идентификатор = ТекПараметр.Идентификатор;
			ЭлементПараметр.Имя = ТекПараметр.Имя;
			ЭлементПараметр.Тип = ТипСтрока;
			ЭлементПараметр.ТипВФорме = Описание;
			ЭлементПараметр.Значение = ЗначениеВСтрокуВнутр(Значение);
			ЭлементПараметр.ЗначениеВФорме = Значение;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСообщениеПользователю(ТекстСообщения, ПутьКДанным)
	ОчиститьСообщения();
	Сообщение = Новый СообщениеПользователю(); 
    Сообщение.Текст = ТекстСообщения;
	Сообщение.ПутьКДанным = ПутьКДанным;
	Сообщение.УстановитьДанные(Объект); 
    Сообщение.Сообщить(); 	
КонецПроцедуры	

&НаСервере
Процедура ПолучитьТабличныеДокументыСравниваемыхЗапросов(ИДПервогоЗапроса, ИДВторогоЗапроса, ФайлПервогоЗапроса, ФайлВторогоЗапроса)
	ФильтрПервого = Новый Структура;
	ФильтрПервого.Вставить("Идентификатор",ИДПервогоЗапроса);
	АдресПервогоДокумента = Объект.Запросы.НайтиСтроки(ФильтрПервого).Получить(0).АдресРезультата;
	
	ФильтрВторого = Новый Структура;
	ФильтрПервого.Вставить("Идентификатор",ИДВторогоЗапроса);
	АдресВторогоДокумента = Объект.Запросы.НайтиСтроки(ФильтрПервого).Получить(0).АдресРезультата;
	
	Если ПустаяСтрока(АдресПервогоДокумента) ИЛИ ПустаяСтрока(АдресВторогоДокумента) Тогда
		Возврат;
	КонецЕсли;
	
	ТДПервогоЗапроса = ПолучитьИзВременногоХранилища(АдресПервогоДокумента);
	ТДВторогоЗапроса = ПолучитьИзВременногоХранилища(АдресВторогоДокумента);
	
	ФайлПервогоЗапроса = ПолучитьИмяВременногоФайла("mxl");
	ТДПервогоЗапроса.Записать(ФайлПервогоЗапроса);
	
	ФайлВторогоЗапроса = ПолучитьИмяВременногоФайла("mxl");
	ТДВторогоЗапроса.Записать(ФайлВторогоЗапроса);
КонецПроцедуры	

// Формирует имя копии запроса.
//
// Параметры:
//	Имя - передаваемое имя запроса.
//
&НаКлиенте
Функция СформироватьИмяКопииЗапроса(Имя)
	Флаг 	= Истина;
	Индекс 	= 1;
	
	Пока Флаг Цикл 
		ФормируемоеИмяЗапроса = НСтр("ru = '%ИмяЗапроса% - Копия %НомерКопии%'");
		ФормируемоеИмяЗапроса = СтрЗаменить(ФормируемоеИмяЗапроса, "%ИмяЗапроса%", Имя);
		ФормируемоеИмяЗапроса = СтрЗаменить(ФормируемоеИмяЗапроса, "%НомерКопии%", Индекс);
		
		Фильтр = Новый Структура;
		Фильтр.Вставить("Имя", ФормируемоеИмяЗапроса);
		
		МассивЗапросовПоФильтру = Объект.Запросы.НайтиСтроки(Фильтр);
		
		Если МассивЗапросовПоФильтру.Количество() = 0 Тогда 
			Флаг = Ложь;
		КонецЕсли;	
		
		Индекс 	= Индекс + 1;
	КонецЦикла;	
	
	Возврат ФормируемоеИмяЗапроса;
КонецФункции	

#КонецОбласти
