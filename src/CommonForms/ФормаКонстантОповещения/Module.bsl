
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
    Отбор = Новый Структура("Метаданные", Метаданные.РегламентныеЗадания.ОповещениеОтветственных);
	РегЗадания = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Отбор);
	
	ЭтотОбъект.РегЗаданиеОтправкиВключено = РегЗадания[0].Использование;
	ЭтотОбъект.РасписаниеОтправки = РегЗадания[0].Расписание; 
	ЭтотОбъект.РегЗаданиеОтправкиРасписание = Строка(ЭтотОбъект.РасписаниеОтправки);
    
    УстановитьПривилегированныйРежим(Истина);
	ДанныеХранилища = РегистрыСведений.БезопасноеХранилище.ПолучитьДанные("НастройкиОтправки");
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ДанныеХранилища <> Неопределено Тогда
		ЭтотОбъект.ПользовательSMTP = ДанныеХранилища.ПользовательSMTP;
		ЭтотОбъект.ПарольSMTP = ДанныеХранилища.ПарольSMTP;
		ЭтотОбъект.ЛогинДляОтправкиSMS = ДанныеХранилища.ЛогинДляОтправкиSMS;
		ЭтотОбъект.ПарольДляОтправкиSMS = ДанныеХранилища.ПарольДляОтправкиSMS;
	КонецЕсли;
    
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписание(НастроитьРасписание)
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(НастроитьРасписание);
	ОписаниеОповещения = Новый ОписаниеОповещения("НастроитьРасписаниеЗавершение", ЭтотОбъект);
	Диалог.Показать(ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеЗавершение(РасписаниеВыбрано, ДополнительныеПараметры) Экспорт
	Если РасписаниеВыбрано <> Неопределено Тогда
		ЭтотОбъект.РасписаниеОтправки = РасписаниеВыбрано;
		ЭтотОбъект.РегЗаданиеОтправкиРасписание = Строка(ЭтотОбъект.РасписаниеОтправки);
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РегЗаданиеОтправкиРасписаниеНажатие(Элемент, СтандартнаяОбработка)
	НастроитьРасписание(ЭтотОбъект.РасписаниеОтправки);
	ЭтотОбъект.РегЗаданиеОтправкиРасписание = Строка(ЭтотОбъект.РасписаниеОтправки);
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Отбор = Новый Структура("Метаданные", Метаданные.РегламентныеЗадания.ОповещениеОтветственных);
	РегЗадания = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Отбор);
	РегЗадания[0].Расписание = ЭтотОбъект.РасписаниеОтправки;
	РегЗадания[0].Использование = ЭтотОбъект.РегЗаданиеОтправкиВключено;
	РегЗадания[0].Записать();
    
    Константы.НастройкаОповещенияВыполнена.Установить(Истина);
    Константы.POP3НастройкиАктуальны.Установить(Истина);
	Константы.SMTPНастройкиАктуальны.Установить(Истина);
	
	Данные = Новый Структура;
	Данные.Вставить("ПользовательSMTP", ЭтотОбъект.ПользовательSMTP);
	Данные.Вставить("ПарольSMTP", ЭтотОбъект.ПарольSMTP);
	Данные.Вставить("ЛогинДляОтправкиSMS", ЭтотОбъект.ЛогинДляОтправкиSMS);
	Данные.Вставить("ПарольДляОтправкиSMS", ЭтотОбъект.ПарольДляОтправкиSMS);
	УстановитьПривилегированныйРежим(Истина);
	РегистрыСведений.БезопасноеХранилище.ЗаписатьДанные("НастройкиОтправки", Данные);
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ПараметрыОповещения = Новый Структура("ВыполнятьОповещениеПоПочте, ВыполнятьОповещениеПоСмс");
	ПараметрыОповещения.ВыполнятьОповещениеПоПочте = НаборКонстант.ВыполнятьОповещениеПоПочте;
	ПараметрыОповещения.ВыполнятьОповещениеПоСмс = НаборКонстант.ВыполнятьОповещениеПоСмс;
	Оповестить("ФормаОбщая.ФормаКонстантОповещения.ПослеЗаписи", ПараметрыОповещения);
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОтправкиРасписаниеНажатие(Элемент)
	НастроитьРасписание(ЭтотОбъект.РасписаниеОтправки);
	ЭтотОбъект.РегЗаданиеОтправкиРасписание = Строка(ЭтотОбъект.РасписаниеОтправки);
	СтандартнаяОбработка = Ложь;
КонецПроцедуры