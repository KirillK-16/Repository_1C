#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ПриЗаписи(Отказ)
	
	ОбновитьРегламентноеЗаданиеОтправкиОтчетов(ЭтотОбъект.Значение);
	
КонецПроцедуры

// Обновляет расписание регламентного задания отправки отчетов
//
Процедура ОбновитьРегламентноеЗаданиеОтправкиОтчетов(ПериодОтправкиОтчетовМин) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	РегламентноеЗадание = РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.ОтправкаОтчета);
	Если Константы.ПосылатьОтчетыЦКК.Получить() Тогда 
		РегламентноеЗадание.Использование = Истина;
		
		Расписание = Новый РасписаниеРегламентногоЗадания;
		Расписание.ПериодПовтораДней = 1;
		Расписание.ПериодПовтораВТечениеДня = ПериодОтправкиОтчетовМин * 60;
		РегламентноеЗадание.Расписание = Расписание;
				
		Если ПустаяСтрока(РегламентноеЗадание.Наименование) Тогда
			РегламентноеЗадание.Наименование = "ОтправкаОтчетовЦКК";
		КонецЕсли;
		
	Иначе
		РегламентноеЗадание.Использование = Ложь;		
	КонецЕсли;
	
	РегламентноеЗадание.Записать();
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецЕсли