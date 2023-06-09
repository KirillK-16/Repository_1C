

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РежимРаботыНаКлиенте = (РежимРаботыНаКлиентеИлиНаСервере = 0);
	
	Элементы.ИмяФайлаВыгрузки.Доступность = Не РежимРаботыНаКлиенте;
	Элементы.ИмяФайлаЗагрузки.Доступность = Не РежимРаботыНаКлиенте;
	
	РежимВыгрузки = (Элементы.ГруппаРежим.ТекущаяСтраница = Элементы.ГруппаРежим.ПодчиненныеЭлементы.ГруппаВыгрузка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗакрытаФормаНастройкиКонсолиЗапросов" Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметр);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИмяФайлаВыгрузкиПриИзменении(Элемент)
	Файл = Новый Файл(ИмяФайлаВыгрузки);
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаЗагрузкиОткрытие(Элемент, СтандартнаяОбработка)
	
	ОткрытьВПриложении(Элемент, "ИмяФайлаЗагрузки", СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаЗагрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбработатьНачалоВыбораФайла(СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура ЗагрузитьДанные(Команда)
	
	ОчиститьСообщения();
	АдресФайлаВоВременномХранилище = "";
	
	Если РежимРаботыНаКлиенте Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьДанныеЗавершение", ЭтотОбъект);
		НачатьПомещениеФайла(ОписаниеОповещения, АдресФайлаВоВременномХранилище,ИмяФайлаЗагрузки,, УникальныйИдентификатор);
		
	Иначе
		Если ПустаяСтрока(ИмяФайлаЗагрузки) Тогда
			
			ТекстСообщения = НСтр("ru='Поле ""Имя файла"" не заполнено'");
			СообщитьПользователю(ТекстСообщения, "ИмяФайлаЗагрузки");
			Возврат;
			
		КонецЕсли;
		
		Файл = Новый Файл(ИмяФайлаЗагрузки);
		Оповещение = Новый ОписаниеОповещения("ОкончаниеПроверкиСуществованияФайла", ЭтотОбъект, Новый Структура("АдресФайлаВоВременномХранилище, ИмяФайлаЗагрузки, ПутьКДаннымСообщения", АдресФайлаВоВременномХранилище, ИмяФайлаЗагрузки, "ИмяФайлаЗагрузки"));
		Файл.НачатьПроверкуСуществования(Оповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеПроверкиСуществованияФайла(Существует, ДополнительныеПараметры) Экспорт
	Если Не Существует Тогда
		ТекстСообщения = НСтр("ru='Файл не существует'");
		СообщитьПользователю(ТекстСообщения, ДополнительныеПараметры.ПутьКДаннымСообщения);
	Иначе
		ЗагрузитьДанныеЗавершение(Истина, ДополнительныеПараметры.АдресФайлаВоВременномХранилище, ДополнительныеПараметры.ИмяФайлаЗагрузки, Неопределено);
	КонецЕсли;
КонецПроцедуры	

&НаКлиенте
Процедура ОкончаниеПроверкиСуществованияФайлаДляЗапуска(Существует, ДополнительныеПараметры) Экспорт
	Если Существует Тогда
		НачатьЗапускПриложения(, ДополнительныеПараметры.ТекстРедактирования);
	Иначе
		СообщитьПользователю(НСтр("ru='Файл не найден'"), ДополнительныеПараметры.ПутьКДанным);
	КонецЕсли;
КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьВПриложении(Элемент, ПутьКДанным, СтандартнаяОбработка)

	Файл = Новый Файл(Элемент.ТекстРедактирования);
	Оповещение = Новый ОписаниеОповещения("ОкончаниеПроверкиСуществованияФайлаДляЗапуска", ЭтотОбъект, Новый Структура("ТекстРедактирования, ПутьКДанным", Элемент.ТекстРедактирования, ПутьКДанным));
	
	Файл.НачатьПроверкуСуществования(Оповещение);
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииРежимаРаботы()
	
	РежимРаботыНаКлиенте = (РежимРаботыНаКлиентеИлиНаСервере = 0);
	
	Элементы.ИмяФайлаВыгрузки.Доступность = Не РежимРаботыНаКлиенте;
	Элементы.ИмяФайлаЗагрузки.Доступность = Не РежимРаботыНаКлиенте;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СообщитьПользователю(Текст, ПутьКДанным = "")
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = Текст;
	Сообщение.ПутьКДанным = ПутьКДанным;
	Сообщение.Сообщить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНачалоВыбораФайла(СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РежимДиалога = ?(РежимВыгрузки, РежимДиалогаВыбораФайла.Сохранение, РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалога);
	ДиалогВыбораФайла.ПроверятьСуществованиеФайла = Не РежимВыгрузки;
	ДиалогВыбораФайла.МножественныйВыбор = Ложь;
	ДиалогВыбораФайла.Заголовок = НСтр("ru='Задайте имя файла выгрузки'");
	ДиалогВыбораФайла.ПолноеИмяФайла = ИмяФайлаЗагрузки;
	
	ДиалогВыбораФайла.Фильтр = "Формат выгрузки(*.xml)|*.xml|Все файлы (*.*)|*.*";
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияДиалогаВыбораФайла", ЭтотОбъект, Новый Структура("ЭтоРежимВыгрузки", РежимВыгрузки));	
	ДиалогВыбораФайла.Показать(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияДиалогаВыбораФайла(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	Если ВыбранныеФайлы <> Неопределено Тогда
		Если ДополнительныеПараметры.ЭтоРежимВыгрузки Тогда
			ИмяФайлаВыгрузки = ВыбранныеФайлы[0];
		Иначе
			ИмяФайлаЗагрузки = ВыбранныеФайлы[0];
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры	

&НаКлиенте
Процедура ЗагрузитьДанныеЗавершение(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Результат Тогда
		
		#Если ВебКлиент Тогда
			ОповещениеОПодключении = Новый ОписаниеОповещения("ПослеПопыткиПодключенияРасширенияРаботыСФайлами", ЭтотОбъект, Новый Структура("Адрес, ВыбранноеИмяФайла", Адрес, ВыбранноеИмяФайла));
			НачатьПодключениеРасширенияРаботыСФайлами(ОповещениеОПодключении);
		#Иначе	
			ПроверитьФайл(ВыбранноеИмяФайла, Адрес);
		#КонецЕсли
		
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПопыткиПодключенияРасширенияРаботыСФайлами(Подключено, ДополнительныеПараметры) Экспорт
	Если Не Подключено Тогда 
		ОповещениеОбУстановке = Новый ОписаниеОповещения("ОбработатьУстановкуРасширенияРаботыСФайлами", ЭтотОбъект, Новый Структура("Адрес, ВыбранноеИмяФайла", ДополнительныеПараметры.Адрес, ДополнительныеПараметры.ВыбранноеИмяФайла));
		НачатьУстановкуРасширенияРаботыСФайлами(ОповещениеОбУстановке);
	Иначе
		ПроверитьФайл(ДополнительныеПараметры.ВыбранноеИмяФайла, ДополнительныеПараметры.Адрес);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьФайл(ВыбранноеИмяФайла, Адрес)
	Состояние(НСтр("ru='Выполняется загрузка данных. Пожалуйста, подождите...'"));
	
	Файл = Новый Файл(ВыбранноеИмяФайла); 
	
	Оповещение = Новый ОписаниеОповещения("ОбработатьПроверкуСуществованияФайла", ЭтотОбъект, Новый Структура("Расширение, Адрес", Файл.Расширение, Адрес));
	Попытка
		Файл.НачатьПроверкуСуществования(Оповещение);
	Исключение
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Сообщение.Сообщить();
	КонецПопытки;	
КонецПроцедуры	

&НаКлиенте
Процедура ОбработатьУстановкуРасширенияРаботыСФайлами(ДополнительныеПараметры) Экспорт
	ПроверитьФайл(ДополнительныеПараметры.ВыбранноеИмяФайла, ДополнительныеПараметры.Адрес);
КонецПроцедуры	

&НаКлиенте
Процедура ОбработатьПроверкуСуществованияФайла(Существует, ДополнительныеПараметры) Экспорт
	Если Не Существует Тогда
		ТекстСообщения = НСтр("ru='Указанный файл не существует'");
		ПутьКДанным = ?(РежимРаботыНаКлиенте, "", "ИмяФайлаЗагрузки");
		СообщитьПользователю(ТекстСообщения, ПутьКДанным);
	Иначе	
		ЗагрузитьДанныеНаСервере(ДополнительныеПараметры.Адрес, ДополнительныеПараметры.Расширение);
	КонецЕсли;
КонецПроцедуры	

&НаСервере
Процедура ЗагрузитьДанныеНаСервере(АдресФайлаВоВременномХранилище, Расширение)
	
	Если РежимРаботыНаКлиенте Тогда
		
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресФайлаВоВременномХранилище);
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла(Расширение);
		ДвоичныеДанные.Записать(ИмяВременногоФайла);
		
	Иначе
		
		ИмяВременногоФайла = ИмяФайлаЗагрузки;
		
	КонецЕсли;
	
	РеквизитФормыВЗначение("Объект").ВыполнитьЗагрузку(ИмяВременногоФайла);
	
	Если РежимРаботыНаКлиенте Тогда
		
		Файл = Новый Файл(ИмяВременногоФайла);
		
		Если Файл.Существует() Тогда
			
			УдалитьФайлы(ИмяВременногоФайла);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаНаКлиентеИлиНаСервереПриИзменении(Элемент)
	
	ПриИзмененииРежимаРаботы();
	
КонецПроцедуры

// выгрузка
&НаСервере
Процедура ВыгрузитьДанныеНаСервере(АдресФайлаВоВременномХранилище)
	
	Если РежимРаботыНаКлиенте Тогда
		
		Расширение = ".xml";
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла(Расширение);
		
	Иначе
		
		ИмяВременногоФайла = ИмяФайлаВыгрузки;
		
	КонецЕсли;
	
	ОбъектНаСервере = РеквизитФормыВЗначение("Объект");
	ОбъектНаСервере.ВыполнитьВыгрузку_10(ИмяВременногоФайла);
	
	Если РежимРаботыНаКлиенте Тогда
		
		Файл = Новый Файл(ИмяВременногоФайла);
		
		Если Файл.Существует() Тогда
			
			ДвоичныеДанные = Новый ДвоичныеДанные(ИмяВременногоФайла);
			АдресФайлаВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
			УдалитьФайлы(ИмяВременногоФайла);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьДанные(Команда)
	Если Не РежимРаботыНаКлиенте Тогда
		
		Если ПустаяСтрока(ИмяФайлаВыгрузки) Тогда
			
			ТекстСообщения = НСтр("ru = 'Поле ""Имя файла"" не заполнено'");
			СообщитьПользователю(ТекстСообщения, "ИмяФайлаВыгрузки");
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Состояние(НСтр("ru = 'Выполняется выгрузка данных. Пожалуйста, подождите...'"));
	
	АдресФайлаВоВременномХранилище = "";
	ВыгрузитьДанныеНаСервере(АдресФайлаВоВременномХранилище);
	
	Если РежимРаботыНаКлиенте И Не ПустаяСтрока(АдресФайлаВоВременномХранилище) Тогда
		
		ИмяФайла = НСтр("ru = 'Файл выгрузки.xml'");
		ПолучитьФайл(АдресФайлаВоВременномХранилище, ИмяФайла);
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузкаНаКлиентеИлиНаСервереПриИзменении(Элемент)
	ПриИзмененииРежимаРаботы();
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаВыгрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбработатьНачалоВыбораФайла(СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаВыгрузкиОткрытие(Элемент, СтандартнаяОбработка)
	ОткрытьВПриложении(Элемент, "ИмяФайлаВыгрузки", СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ГруппаРежимПриСменеСтраницы(Элемент, ТекущаяСтраница)
	РежимВыгрузки = (Элементы.ГруппаРежим.ТекущаяСтраница = Элементы.ГруппаРежим.ПодчиненныеЭлементы.ГруппаВыгрузка);
КонецПроцедуры

#КонецОбласти
