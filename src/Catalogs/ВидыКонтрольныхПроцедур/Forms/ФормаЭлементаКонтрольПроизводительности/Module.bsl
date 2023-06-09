&НаКлиенте
Перем РасписаниеЗадания Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
	
	Если Общий.ЭтоНовыйОбъект(Объект) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ИменаНовыхЭлементов = НастройкиСервер.ЗаполнитьПоляДинамическихНастроекНаФорме(Объект.Ссылка, ЭтотОбъект, "НастройкиБизнесПроцесса");
	НастройкиСервер.ЗаполнитьПоляОтветственныхПоКонтрольнойПроцедуре(Объект.Ссылка, ЭтотОбъект, "ОтветственныеГруппа");
	ОбновитьРекомендации();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РасписаниеКлиент.ОбновитьРасписание(ЭтотОбъект, ПолучитьРасписаниеНаФормеНаСервере(Объект.Ссылка));
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьРасписаниеНаФормеНаСервере(Ссылка)
	Возврат РасписаниеСервер.ПолучитьРасписание(Ссылка);
КонецФункции

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	НастройкиСервер.РазобратьИСохранитьДинамическиеНастройки(ТекущийОбъект.Ссылка, ЭтотОбъект, "НастройкиБизнесПроцесса");
	НастройкиСервер.СохранитьОтветственных(ТекущийОбъект.Ссылка, ЭтотОбъект, "ОтветственныеГруппа");
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	РасписаниеСервер.СохранитьРасписание(ЭтотОбъект, ТекущийОбъект.Ссылка, АдресВременногоХранилищаРасписания);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Изменение.Справочник.ВидыКонтрольныхПроцедур", Объект.Ссылка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОповещатьПриУхудшенииАпдексаПриИзменении(Элемент)
	Элементы.ПороговоеЗначениеПадения.Доступность = ОповещатьПриУхудшенииАпдекса;
	УстановитьМодифицированностьФормы();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура НастроитьРасписание(Команда)	
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НастроитьРасписаниеЗавершение", ЭтотОбъект);
	РасписаниеКлиент.НастроитьРасписаниеПоложитьВоВременноеХранилище(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеЗавершение(Адрес, ДополнительныеПараметры) Экспорт
	
	Если Адрес <> Неопределено Тогда
		// значит настройка была выполнена и новое значение лежит во временном хранилище
		АдресВременногоХранилищаРасписания = Адрес;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьРекомендации()
	
	ИмяМакета = НазваниеСтраницыСправки();
	Если ИмяМакета <> Неопределено Тогда
		Справка = Общий.ТекстHTMLМакета(НазваниеСтраницыСправки()); 
	Иначе
		Элементы.Рекомендации.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция НазваниеСтраницыСправки()
	
	Возврат Объект.ИмяБизнесПроцесса;	
	
КонецФункции

 &НаКлиенте
Процедура УстановитьМодифицированностьФормы()
	ЭтотОбъект.Модифицированность = Истина;
КонецПроцедуры	


