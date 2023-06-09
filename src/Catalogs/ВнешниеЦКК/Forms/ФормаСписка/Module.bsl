&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Отбор = Новый Структура("Метаданные", Метаданные.РегламентныеЗадания.ОтправкаСтатистикиВнешнимЦКК);
	РегЗадания = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Отбор);
	
	ЭтотОбъект.РасписаниеОтправкиВключено = РегЗадания[0].Использование;
	ЭтотОбъект.РасписаниеОтправки = РегЗадания[0].Расписание; 
	ЭтотОбъект.РасписаниеОтправкиПредставление = Строка(ЭтотОбъект.РасписаниеОтправки);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПодключитьОбработчикОжидания("ОбновитьДанныеДляОбработки", 10);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанныеДляОбработки()
	ЭтотОбъект.Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура РасписаниеОтправкиВключеноПриИзменении(Элемент)
	РасписаниеОтправкиВключеноПриИзмененииНаСервере(ЭтотОбъект.РасписаниеОтправкиВключено);
КонецПроцедуры

&НаСервереБезКонтекста
Процедура РасписаниеОтправкиВключеноПриИзмененииНаСервере(Парам)
	Отбор = Новый Структура("Метаданные", Метаданные.РегламентныеЗадания.ОтправкаСтатистикиВнешнимЦКК);
	РегЗадания = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Отбор);
	РегЗадания[0].Использование = Парам;
	РегЗадания[0].Записать();
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияРасписаниеНажатие(Элемент)
	НастроитьРасписание();
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура РасписаниеОтправкиПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	НастроитьРасписание();
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписание()
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(ЭтотОбъект.РасписаниеОтправки);
	ОписаниеОповещения = Новый ОписаниеОповещения("НастроитьРасписаниеЗавершение", ЭтотОбъект);
	Диалог.Показать(ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеЗавершение(РасписаниеВыбрано, ДополнительныеПараметры) Экспорт
	Если РасписаниеВыбрано <> Неопределено Тогда
		ЗаписатьРасписание(РасписаниеВыбрано);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаписатьРасписание(Знач Расписание)
	Отбор = Новый Структура("Метаданные", Метаданные.РегламентныеЗадания.ОтправкаСтатистикиВнешнимЦКК);
	РегЗадания = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Отбор);
	РегЗадания[0].Расписание = Расписание;
	РегЗадания[0].Записать();
	
	ЭтотОбъект.РасписаниеОтправки = Расписание;
	ЭтотОбъект.РасписаниеОтправкиПредставление = Строка(ЭтотОбъект.РасписаниеОтправки);
КонецПроцедуры



