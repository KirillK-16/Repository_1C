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
		
	Если ДополнительныеСвойства.Свойство("Программно") И ДополнительныеСвойства.Программно Тогда
		Если ДополнительныеСвойства.Свойство("Расписание") Тогда
			УстановитьРасписание(ДополнительныеСвойства.Расписание);
		КонецЕсли;
		
		Возврат;
	КонецЕсли;
		
	Если не ПроверитьКорректностьЗаполнения(Истина) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	
	
	//фильтр для ускорения выборки оповещений по инциденту (явно указываем отбор по типу в отдельное поле)
	
	ОтноситсяКТипуИнцидента = неопределено;
	
	Если НЕ ПустаяСтрока(НастройкиОтбораДляИнцидентов) Тогда
	
		КН = Новый КомпоновщикНастроекКомпоновкиДанных();
		
		Справочники.Оповещения.НастройкиОтбораДляИнцидентовДесериализация(КН, НастройкиОтбораДляИнцидентов);
		
		Если КН.Настройки.Отбор.Элементы.Количество() = 0 Тогда
			ВызватьИсключение "Не заполнены настройки отбора инцидентов для оповещения!";
		КонецЕсли;
			
		Для Каждого ЭлементОтбора из КН.Настройки.Отбор.Элементы Цикл
			Если
				ТипЗнч(ЭлементОтбора)=Тип("ЭлементОтбораКомпоновкиДанных") И
				Строка(ЭлементОтбора.ЛевоеЗначение)="ТипИнцидента" И
				ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно И
				ЭлементОтбора.Использование Тогда
				
				ОтноситсяКТипуИнцидента = ЭлементОтбора.ПравоеЗначение;
				Прервать;
			
			КонецЕсли;
		КонецЦикла;
	Иначе
		ВызватьИсключение "Не заполнены настройки отбора инцидентов для оповещения!";
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("Расписание") Тогда
		УстановитьРасписание(ДополнительныеСвойства.Расписание);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
		
	Если ДополнительныеСвойства.Свойство("НеПроверять") Тогда
		Если ДополнительныеСвойства.НеПроверять Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
    
    Если ДополнительныеСвойства.Свойство("Использование") Тогда
        Если ЗначениеЗаполнено(ИсполняющееЗадание) Тогда
            ОчередьЗаданий.ИзменитьЗадание(ИсполняющееЗадание, Новый Структура("Использование", ДополнительныеСвойства.Использование));
        КонецЕсли;
    Иначе
        Если ЗначениеЗаполнено(ИсполняющееЗадание) Тогда
            ОчередьЗаданий.ИзменитьЗадание(ИсполняющееЗадание, Новый Структура("Использование", Ложь));
        КонецЕсли;
    КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьРасписание(Знач Расписание)
	
	Если Расписание = Неопределено Тогда
		Расписание = Новый РасписаниеРегламентногоЗадания;
		Расписание.ПериодПовтораДней = 1;
		Расписание.ПериодНедель = 1;
		Расписание.ПериодПовтораВТечениеДня = 20;
	КонецЕсли;
		
	Если ДополнительныеСвойства.Свойство("Использование") Тогда
		Использование = ДополнительныеСвойства.Использование;
	Иначе
		Использование = Ложь;
	КонецЕсли;
		
	Если Общий.СсылкаСуществует(ИсполняющееЗадание) Тогда
		Если ИсполняющееЗадание.СостояниеЗадания <> Перечисления.СостоянияЗаданий.НеАктивно Тогда
			Если Строка(ИсполняющееЗадание.Расписание.Получить()) <> Строка(Расписание) Тогда
				ОчередьЗаданий.ИзменитьЗадание(ИсполняющееЗадание, Новый Структура("Расписание, Использование", Расписание, Использование));
			КонецЕсли;
		КонецЕсли;
	Иначе
		ПараметрыЗадания = Новый Массив;
		Если ЭтоНовый() Тогда
			СсылкаНового = Справочники.Оповещения.ПолучитьСсылку();
			УстановитьСсылкуНового(СсылкаНового);
			ПараметрыЗадания.Добавить(СсылкаНового);
		Иначе
			ПараметрыЗадания.Добавить(Ссылка);
		КонецЕсли;
					
		ПараметрыСоздания = Новый Структура;
		ПараметрыСоздания.Вставить("Использование",Использование);
		
		РасписаниеОчереди = Новый РасписаниеРегламентногоЗадания;
		РасписаниеОчереди.ПериодПовтораДней = 1;
		РасписаниеОчереди.ПериодПовтораВТечениеДня = 20;
		ПараметрыСоздания.Вставить("Расписание", РасписаниеОчереди);
		
		ПараметрыСоздания.Вставить("ИмяМетода", "Справочники.Оповещения.ВыполнитьПовторноеОповещение");
		ПараметрыСоздания.Вставить("Параметры", ПараметрыЗадания);
		Если ДополнительныеСвойства.Свойство("ЗапланированныйМоментЗапуска") Тогда
			ПараметрыСоздания.Вставить("ЗапланированныйМоментЗапуска", ДополнительныеСвойства.ЗапланированныйМоментЗапуска);
		КонецЕсли;
		ПараметрыСоздания.Вставить("Наименование", Наименование);
		ПараметрыСоздания.Вставить("НавигационнаяСсылкаВладельцаЗадания", ПолучитьНавигационнуюСсылку(ЭтотОбъект.ПолучитьСсылкуНового()));
				
		ИсполняющееЗадание = ОчередьЗаданий.ДобавитьЗадание(ПараметрыСоздания);
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
	Если ИсполняющееЗадание = Неопределено Тогда
		Если СообщатьОбОшибках Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Поле = "РасписаниеПредставление";
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Текст = ЭтотОбъект.Наименование + ": Укажите расписание!";
			Сообщение.Сообщить();
		КонецЕсли;
		Результат = Ложь;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ТекстОповещения) И НЕ ВключитьПоказателиВТекстОповещения Тогда
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

Процедура ПередУдалением(Отказ)
	Если Общий.СсылкаСуществует(ИсполняющееЗадание) Тогда
		ИсполняющееЗадание.ПолучитьОбъект().Удалить();
	КонецЕсли;
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
    
    ИсполняющееЗадание = Неопределено;
    
КонецПроцедуры

#КонецЕсли
