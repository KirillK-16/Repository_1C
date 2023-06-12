#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РасписаниеБуфер = Новый РасписаниеРегламентногоЗадания;
	РасписаниеБуфер.ПериодПовтораДней = 1;
	РасписаниеБуфер.ПериодНедель = 1;
	РасписаниеБуфер.ПериодПовтораВТечениеДня = 20;
	РасписаниеПредставление = Строка(РасписаниеБуфер);
	
	Если ДополнительныеСвойства.Свойство("НеПроверять") Тогда
		Если ДополнительныеСвойства.НеПроверять Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
		
	Если не ПроверитьКорректностьЗаполнения(Истина) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
		
	Если ДополнительныеСвойства.Свойство("НеПроверять") Тогда
		Если ДополнительныеСвойства.НеПроверять Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Проверяет корректность заполнения данных перед включением оповещения
//
// Параметры:
//  СообщатьОбОшибках - Булево - признак того, что нужно формировать сообщения о незаполненных полях
//
// Возвращаемое значение:
//  Булево
//
Функция ПроверитьКорректностьЗаполнения(Знач СообщатьОбОшибках) Экспорт
	
	Если ДополнительныеСвойства.Свойство("НеПроверять") Тогда
		НеПроверять = ДополнительныеСвойства.НеПроверять;
		Если НеПроверять Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
		
	Результат = Истина;

	Если Не ЗначениеЗаполнено(ТекстОповещения) Тогда
		Если СообщатьОбОшибках Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Поле = "ТекстОповещения";
			Сообщение.Текст = ЭтотОбъект.Наименование + ": Укажите текст оповещения!";
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Сообщить();
		КонецЕсли;
		Результат = Ложь;
	КонецЕсли;
	Если Получатели.Количество() = 0 Тогда
		Если СообщатьОбОшибках Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Поле = "Получатели";
			Сообщение.Текст = ЭтотОбъект.Наименование + ": Укажите хотя бы одного получателя!";
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Сообщить();
		КонецЕсли;
		Результат = Ложь;
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

#КонецЕсли
