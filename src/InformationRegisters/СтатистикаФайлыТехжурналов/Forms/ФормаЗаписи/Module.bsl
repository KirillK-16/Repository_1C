
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЧтениеТекста = Новый ЧтениеТекста();
	
	ЧтениеТекста.Открыть(Запись.ПолноеИмяФайла, КодировкаТекста.UTF8,, "☺",Ложь);
	ЧтениеТекста.Прочитать(Запись.ПозицияЧтения);
	
	ЭтотОбъект.НовыеДанные = ЧтениеТекста.Прочитать();
	
	ЧтениеТекста.Закрыть();
КонецПроцедуры
