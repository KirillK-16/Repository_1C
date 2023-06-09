
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Отбор = Новый Структура("Метаданные", Метаданные.РегламентныеЗадания.УдалениеУстаревшихДанных);
	РегЗадания = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Отбор);
	
	ЭтотОбъект.РегЗаданиеВключено = РегЗадания[0].Использование;
	ЭтотОбъект.Расписание = РегЗадания[0].Расписание;
	
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
		ЭтотОбъект.Расписание = РасписаниеВыбрано;
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияРасписаниеНажатие(Элемент)
	
	НастроитьРасписание(ЭтотОбъект.Расписание);
	
КонецПроцедуры

&НаКлиенте
Процедура РасписаниеНажатие(Элемент, СтандартнаяОбработка)
	
	НастроитьРасписание(ЭтотОбъект.Расписание);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Отбор = Новый Структура("Метаданные", Метаданные.РегламентныеЗадания.УдалениеУстаревшихДанных);
	РегЗадания = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Отбор);
	РегЗадания[0].Расписание = ЭтотОбъект.Расписание;
	РегЗадания[0].Использование = ЭтотОбъект.РегЗаданиеВключено;
	РегЗадания[0].Записать();
	
КонецПроцедуры
